import 'dart:async';

import 'package:location/location.dart';
import 'package:sensors/sensors.dart';

class SpeedProvider {
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  SpeedProvider() {
    _requestPermission();
  }

  void _requestPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

// get the device speed
  Stream<LocationData> getCarSpeedStream() {
    return _location.onLocationChanged;
  }

  Stream<AccelerometerEvent> calculateAcceleration() {
    return accelerometerEvents;
  }
}
