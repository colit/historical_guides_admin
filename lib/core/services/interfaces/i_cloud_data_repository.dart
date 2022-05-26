import 'dart:typed_data';

import 'package:historical_guides_admin/core/models/track_point.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:latlong2/latlong.dart';

abstract class ICloudDataRepository {
  Future<void> uploadTrackPoints(List<TrackPoint> points);

  Future<void> createTour(
    String geoJSON,
    String name,
    double length,
    LatLng start,
    List<LatLng> bounds,
  );

  Future<List<Tour>> getTours();

  Future<bool> deleteTour(String id);

  Future<Tour> getTourDetails(String tourId);

  Future<void> updateTour(Tour tour);

  Future<int> countImages();

  Future<List<ImageEntity>> getImages(int skip);

  Future<ImageEntity> getImageDetails(int id);

  Future<void> deleteImage(ImageEntity newImage);

  Future<String> uploadImage(Uint8List imageData);

  Future<void> updateImage(ImageEntity newImage, Uint8List? imageData);

  Future<List<ImageEntity>> getImagesAroundStation(LatLng latLng);

  // Future<void> createUUIDs();
}
