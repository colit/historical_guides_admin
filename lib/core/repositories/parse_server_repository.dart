import 'package:historical_guides_admin/core/commons/graphql_setup.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:http/http.dart';
import 'dart:typed_data';

import 'package:graphql/client.dart';
import 'package:historical_guides_admin/core/models/track_point.dart';
import 'package:http_parser/http_parser.dart';

import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../exeptions/general_exeption.dart';
import '../services/interfaces/i_cloud_data_repository.dart';

class ParseServerRepository implements ICloudDataRepository {
  final _httpLink = HttpLink(
    GraphQLSetup.graphqlAPI,
    defaultHeaders: GraphQLSetup.graphQLHeader,
  );

  GraphQLClient? _client;
  GraphQLClient get client {
    return _client ??= GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(GraphQLSetup.graphqlAPI,
          defaultHeaders: GraphQLSetup.graphQLHeader),
    );
  }

  Future<GraphQLClient> getClient() async {
    /// initialize Hive and wrap the default box in a HiveStore
    final store = await HiveStore.open(path: 'my/cache/path');
    return GraphQLClient(
      /// pass the store to the cache for persistence
      cache: GraphQLCache(store: store),
      link: _httpLink,
    );
  }

  @override
  Future<void> uploadTrackPoints(List<TrackPoint> points) async {
    // create track

    final client = await getClient();

    const String createTrack = r'''
      mutation CreateTrack($trackName: String!) {
        createTrack (input: {
          fields: {
            name: $trackName
          }
        }) {
          track {
            objectId
            name
          }
        }
      }
    ''';

    const String createPoint = r'''
      mutation CreatePoint($lat: Float!, $lon: Float!, $elevation: Float = 0.0) {
        createPoint(
          input: {
            fields: { position: { latitude: $lat, longitude: $lon }, elevation: $elevation }
          }
        ) {
          point {
            objectId
            position {
              latitude
              longitude
            }
            elevation
          }
        }
      }
    ''';

    const String addPointToTrack = r'''
      mutation addPointToTrack($trackId: ID!, $point: PointRelationInput!) {
        updateTrack(input: { id: $trackId, fields: {points: $point}}) {
          track {
            objectId
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(createTrack),
      variables: <String, dynamic>{
        'trackName': 'my track',
      },
    );

    final trackResult = await client.mutate(options);
    if (trackResult.hasException) {
      print(trackResult.exception.toString());
      return;
    }

    final trackId = trackResult.data?['createTrack']['track']['objectId'];

    // upload points
    print('total: ${points.length}');
    for (final point in points) {
      // create point
      final pointResult = await client.mutate(MutationOptions(
        document: gql(createPoint),
        variables: <String, dynamic>{
          'lat': point.latitude,
          'lon': point.longitude,
          'elevation': point.elevation,
        },
      ));
      if (pointResult.hasException) {
        print(pointResult.exception.toString());
        return;
      }

      final pointId = pointResult.data?['createPoint']['point']['objectId'];

      // assign point to track
      final addResult = await client.mutate(
        MutationOptions(
          document: gql(addPointToTrack),
          variables: <String, dynamic>{
            'trackId': trackId,
            'point': {'add': pointId},
          },
        ),
      );
      if (addResult.hasException) {
        print(addResult.exception.toString());
        return;
      }
    }
  }

  @override
  Future<void> createTour(
    String geoJSON,
    String name,
    double length,
    LatLng start,
    List<LatLng> bounds,
  ) async {
    final client = await getClient();

    final rawGeoJson = Uint8List.fromList(geoJSON.codeUnits);

    var multipartFile = MultipartFile.fromBytes(
      'geojson',
      rawGeoJson,
      filename: '${DateTime.now().second}.geojson',
      contentType: MediaType("application", "geo+json"),
    );

    final trackResult = await client.mutate(
      MutationOptions(
        document: gql(GraphQLQueries.createTour),
        variables: <String, dynamic>{
          'file': multipartFile,
          'name': name,
          'length': length,
          'startLat': start.latitude,
          'startLong': start.longitude,
          'swLat': bounds[0].latitude,
          'swLong': bounds[0].longitude,
          'neLat': bounds[1].latitude,
          'neLong': bounds[1].longitude,
        },
      ),
    );
    if (trackResult.hasException) {
      print(trackResult.exception.toString());
      return;
    }
  }

  @override
  Future<List<Tour>> getTours() async {
    final options = QueryOptions(
      document: gql(GraphQLQueries.getTours),
    );

    final result = await client.query(options);

    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Server Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      final tours = List<Tour>.from(result.data?['tracks']['edges']
          .map((node) => Tour.fromGraphQL(node['node'])));
      return tours;
    }
  }

  @override
  Future<bool> deleteTour(String id) async {
    final trackResult = await client.mutate(
      MutationOptions(
        document: gql(GraphQLQueries.deleteTour),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );
    return !trackResult.hasException;
  }

  @override
  Future<Tour> getTourDetails(String tourId) async {
    final options = QueryOptions(
      document: gql(GraphQLQueries.getTourDetails),
      variables: {
        'id': tourId,
      },
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await client.query(options);
    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Server Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      final tour = Tour.fromGraphQL(
          List.from(result.data?['tracks']['edges']).first['node']);
      print('loaded tour with ${tour.pointsOfInterest.length} points');
      return tour;
    }
  }

  @override
  Future<void> updateTour(Tour tour) async {
    // delete points
    final pointsToRemove = tour.pointsOfInterest.where(
      (e) => e.removed && e.id != null,
    );
    for (final point in pointsToRemove) {
      final pointObject = ParseObject('PointOfInterest')..objectId = point.id;
      await pointObject.delete();
    }
    print('deleted: ${pointsToRemove.length}');

    final objects = <ParseObject>[];

    // update points
    final pointsToUpdate = tour.pointsOfInterest.where(
      (e) => !e.removed && e.id != null,
    );
    for (final point in pointsToUpdate) {
      final pointObject = ParseObject('PointOfInterest')
        ..objectId = point.id
        ..set(
            'position',
            ParseGeoPoint(
              latitude: point.position.latitude,
              longitude: point.position.longitude,
            ))
        ..set('title', point.titel)
        ..set('desctiption', point.description);
      final apiResponse = await pointObject.save();
      if (apiResponse.success && apiResponse.results != null) {
        objects.add(apiResponse.results?.first as ParseObject);
      }
    }
    print('updated: ${pointsToUpdate.length}');

    // create points
    final pointsToCreate = tour.pointsOfInterest.where(
      (e) => !e.removed && e.id == null,
    );
    for (final point in pointsToCreate) {
      final pointObject = ParseObject('PointOfInterest')
        ..set(
            'position',
            ParseGeoPoint(
              latitude: point.position.latitude,
              longitude: point.position.longitude,
            ))
        ..set('title', point.titel)
        ..set('desctiption', point.description);
      final apiResponse = await pointObject.save();
      if (apiResponse.success && apiResponse.results != null) {
        objects.add(apiResponse.results?.first as ParseObject);
      }
    }
    print('created: ${pointsToCreate.length}');

    var newTour = ParseObject('Track')
      ..objectId = tour.id
      ..set('stations', objects);
    await newTour.save();
    print('+++ saved');
  }
}

// --------- Upload file with Parse SDK
  // final parseFile = ParseWebFile(Uint8List.fromList(geoJSON.codeUnits),
  //     name: 'track.geojson');
  // final responce = await parseFile.save();
  // if (responce.success) {
  //   final track = ParseObject('Track')
  //     ..set('name', name)
  //     ..set('length', length)
  //     ..set(
  //         'start',
  //         ParseGeoPoint(
  //           latitude: start.latitude,
  //           longitude: start.longitude,
  //         ))
  //     ..set('bounds', [
  //       ParseGeoPoint(
  //         latitude: bounds[0].latitude,
  //         longitude: bounds[0].longitude,
  //       ),
  //       ParseGeoPoint(
  //         latitude: bounds[1].latitude,
  //         longitude: bounds[1].longitude,
  //       ),
  //     ])
  //     ..set('geojson', parseFile);
  //   final resTrack = await track.save();
  //   if (!resTrack.success) {
  //     throw Exception();
  //   }
  // } else {
  //   throw Exception();
  // }

  // @override
  // Future<void> createUUIDs() async {
  //   int skip = 0;
  //   bool shouldContinue = true;
  //   while (shouldContinue) {
  //     final queryImages = QueryBuilder<ParseObject>(ParseObject('Image'))
  //       ..setAmountToSkip(skip);
  //     final apiResponse = await queryImages.query();

  //     if (apiResponse.success && apiResponse.results != null) {
  //       final results = List<ParseObject>.from(apiResponse.results!);
  //       skip += results.length;
  //       print('------ $skip');
  //       shouldContinue = results.isNotEmpty;
  //       for (final imageObject in results) {
  //         final objectId = imageObject.get('objectId');
  //         final uuid = Random().nextInt(pow(2, 31).floor() - 1);
  //         final image = ParseObject('Image')
  //           ..objectId = objectId
  //           ..set('uuid', uuid);
  //         await image.save();
  //         print(uuid);
  //       }
  //     } else {
  //       throw Exception();
  //     }
  //   }
  // }

// final filename = 'track.geojson';
    // var request = http.MultipartRequest('POST',
    //     Uri.parse('https://parseapi.back4app.com/parse/files/$filename'))
    //   ..files.add(
    //     http.MultipartFile.fromString(
    //       'geojson',
    //       track,
    //       contentType: MediaType('application', 'json'),
    //       filename: filename,
    //     ),
    //   )
    //   ..headers.addAll({
    //     'X-Parse-Application-Id': '',
    //     'X-Parse-REST-API-Key': '',
    //   });
    // var res = await request.send()
    //   ..stream.listen((value) {
    //     print(String.fromCharCodes(value));
    //   });

    // if (res.statusCode == 201) {
    //   print('Uploaded!');
    // }

    // final dio = Dio();

    // final response = await dio.post(
    //   'https://parseapi.back4app.com/parse/files/track.geojson',
    //   data: FormData.fromMap({
    //     'file': MultipartFile.fromString(
    //       track,
    //       filename: 'track.geojson',
    //       contentType: MediaType('application', 'json'),
    //     ),
    //   }),
    //   options: Options(
    //     method: 'POST',
    //     responseType: ResponseType.json,
    //     headers: {
    //       'X-Parse-Application-Id': '',
    //       'X-Parse-REST-API-Key': '',
    //     },
    //   ),
    // );
    // print(response);
