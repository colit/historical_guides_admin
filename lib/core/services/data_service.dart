import 'dart:typed_data';

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

  Future<List<ImageEntity>> getImages(int cursor) async {
    final images = _cloudDataRepository.getImages(cursor);
    return images;
  }

  Future<bool> removeTour(String id) async {
    return await _cloudDataRepository.deleteTour(id);
  }

  Future<Tour> getTourDetails(String tourId) async {
    _currentTour = await _cloudDataRepository.getTourDetails(tourId);
    return _currentTour!;
  }

  void updateCurrentTour({
    required String id,
    required double latitude,
    required double longitude,
    required String title,
    String? description,
    List<ImageEntity> images = const [],
  }) {
    if (_currentTour == null) return;
    final pois = _currentTour!.stations;
    final index = pois.indexWhere((e) => e.id == id);
    final station = Station(
      id: id,
      titel: title,
      position: LatLng(latitude, longitude),
      description: description,
      images: images,
    );
    if (index < 0) {
      pois.add(station);
    } else {
      pois
        ..removeAt(index)
        ..insert(index, station);
    }
    _currentTour = _currentTour!.copyWith(stations: pois);
    notifyListeners();
  }

  Future<void> saveTour() async {
    print(_currentTour!.name);
    await _cloudDataRepository.updateTour(_currentTour!);
  }

  void updateTour(Tour? newTour) {
    _currentTour = newTour;
    notifyListeners();
  }

  void updateStationsOrder(int oldIndex, int newIndex) {
    if (_currentTour == null) return;
    // get all stations were not removed
    final visibleStations =
        _currentTour!.stations.where((e) => !e.removed).toList();
    // reorder stations
    visibleStations.insert(
      newIndex <= oldIndex ? newIndex : newIndex - 1,
      visibleStations.removeAt(oldIndex),
    );
    // add removed stations
    visibleStations.addAll(_currentTour!.stations.where((e) => e.removed));
    // update stations in tour
    _currentTour = _currentTour!.copyWith(stations: visibleStations);
  }

  void hideStation(String id) {
    if (_currentTour != null) {
      _currentTour = _currentTour?.hideStation(id);
      // notifyListeners();
    }
  }

  void onLeaveEditorPage() {
    _currentTour = _currentTour?.showAllStations();
    notifyListeners();
  }

  Future<ImageEntity> getImageDetails(int id) {
    return _cloudDataRepository.getImageDetails(id);
  }

  Future<void> updateImage(
    ImageEntity newImage, {
    Uint8List? imageData,
    bool create = false,
    String? imageName,
  }) async {
    await _cloudDataRepository.updateImage(newImage, imageData, imageName);
    notifyListeners();
  }

  Future<void> deleteImage(ImageEntity image) async {
    await _cloudDataRepository.deleteImage(image);
    notifyListeners();
  }

  Future<int> countImages() async {
    return _cloudDataRepository.countImages();
  }

  Future<List<ImageEntity>> getImagesAroundStation(
      double latitude, double longitude) async {
    return _cloudDataRepository.getImagesAroundStation(
      LatLng(latitude, longitude),
    );
  }

  Future<void> saveStation(Station station, {bool createNew = true}) async {
    if (createNew) {
      final stationId = await _cloudDataRepository.createStation(station);
      if (_currentTour != null) {
        await _cloudDataRepository.addStationToTour(_currentTour!, stationId);
      }
    } else {
      await _cloudDataRepository.updateStation(station);
    }
  }
}
