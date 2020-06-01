import 'dart:async';

import 'package:location/location.dart';

class SpeedProvider {
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  SpeedProvider() {
    _requestPermission();
  }

  void _requestPermission() async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

// get the device speed
  Stream<LocationData> getCarSpeedStream() {
    return _location.onLocationChanged;
  }
}
