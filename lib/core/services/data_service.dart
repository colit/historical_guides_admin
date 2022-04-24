import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/interfaces/i_cloud_data_repository.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:latlong2/latlong.dart';

import '../models/track_point.dart';

class DataService extends ChangeNotifier {
  DataService();
  late final ICloudDataRepository _cloudDataRepository;

  Tour? _currentTour;

  Tour? get currentTour => _currentTour;

  void update(ICloudDataRepository cloudDataRepository) {
    _cloudDataRepository = cloudDataRepository;
  }

  Future<void> uploadTrackPoints(List<TrackPoint> points) async {
    await _cloudDataRepository.uploadTrackPoints(points);
  }

  Future<void> createTour(
    String track, {
    String name = 'Track Name',
    double length = 0,
    required LatLng start,
    required List<LatLng> bounds,
  }) async {
    await _cloudDataRepository.createTour(
      track,
      name,
      length,
      start,
      bounds,
    );
  }

  Future<List<Tour>> getToursList() async {
    final tours = _cloudDataRepository.getTours();
    return tours;
  }

  Future<void> getImages() async {}

  Future<bool> removeTour(String id) async {
    return await _cloudDataRepository.deleteTour(id);
  }

  Future<Tour> getTourDetails(String tourId) async {
    _currentTour = await _cloudDataRepository.getTourDetails(tourId);
    return _currentTour!;
  }

  void updateCurrentTour({
    required double latitude,
    required double longitude,
    required String title,
    String? description,
  }) {
    if (_currentTour == null) return;
    var pois = _currentTour!.pointsOfInterest;
    pois.add(PointOfInterest(
      titel: title,
      position: LatLng(latitude, longitude),
      description: description,
    ));
    _currentTour = _currentTour!.copyWith(pointsOfInterest: pois);
    notifyListeners();
  }
}
