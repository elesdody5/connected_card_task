import 'dart:async';

import 'package:connectedcardtask/provider/speed_provider.dart';
import 'package:connectedcardtask/widget/seven_segment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeedProvider _speedProvider = SpeedProvider();
  Timer _timer;
  int _start = 0;
  int _from10_30 = 0;
  int _from30_10 = 0;
  double _previousSpeed;
  double _speed;

  Widget _buildFrom10To30() {
    // start counting when speed is 10 and increasing
    if (_speed.truncate() == 10 && _speed > _previousSpeed) _startCounting();
    if (_speed.truncate() == 30 && _speed > _previousSpeed)
      _endCountFrom10To30();
    return SevenSegment(_from10_30.toString(), size: 6);
  }

  Widget _buildFrom30To10() {
    // start counting when speed is 10 and increasing
    if (_speed.truncate() == 30 && _speed < _previousSpeed) _startCounting();
    if (_speed.truncate() == 10 && _speed < _previousSpeed)
      _endCountFrom30To10();
    return SevenSegment(_from30_10.toString(), size: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connected Car Task"),
        ),
        body: StreamBuilder<LocationData>(
          stream: _speedProvider.getCarSpeedStream(),
          builder: (context, snapshot) {
            _previousSpeed = _speed;
            // convert speed from m/s to km/hr
            _speed = snapshot.hasData ? (snapshot.data.speed) * 3.6 : 0;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Current Speed ",
                        style: Theme.of(context).textTheme.title,
                      ),
                      SevenSegment(_speed.toInt().toString(), size: 12),
                      Text(
                        "Kmh",
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        "From 10 to 30",
                        style: Theme.of(context).textTheme.title,
                      ),
                      _buildFrom10To30(),
                      Text("Seconds", style: Theme.of(context).textTheme.title),
                      Text(
                        "From 30 to 10",
                        style: Theme.of(context).textTheme.title,
                      ),
                      _buildFrom30To10(),
                      Text("Seconds", style: Theme.of(context).textTheme.title),
                    ],
                  ),
                ));
          },
        ));
  }

  void _startCounting() {
    _showToast();
    _start = 0;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) => _start = _start + 1);
  }

  void _endCountFrom10To30() {
    if (_start != 0) _from10_30 = _start;
    if (_timer != null) _timer.cancel();
    _start = 0;
  }

  void _endCountFrom30To10() {
    if (_start != 0) _from30_10 = _start;
    if (_timer != null) _timer.cancel();
    _start = 0;
  }

  void _showToast() {
    Fluttertoast.showToast(
        msg: "Start Counter",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreenAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
