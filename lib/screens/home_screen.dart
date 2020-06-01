import 'package:connectedcardtask/provider/speed_provider.dart';
import 'package:connectedcardtask/widget/seven_segment.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeedProvider _speedProvider = SpeedProvider();

  Widget _buildSpeedWidget() {
    return StreamBuilder<LocationData>(
        stream: _speedProvider.getCarSpeedStream(),
        builder: (context, snapshot) {
          // convert speed from m/s to km/hr
          double speed = snapshot.hasData ? (snapshot.data.speed) * 3.6 : 0;
          return SevenSegment(speed.toInt().toString(), size: 12);
        });
  }

  Widget _buildTimeWidget() {
    return StreamBuilder<AccelerometerEvent>(
      stream: _speedProvider.calculateAcceleration(),
      builder: (context, snapshot) {
        int acceleration = snapshot.hasData ? snapshot.data.x.toInt() : 0;
        print(acceleration);
        double time = acceleration != 0 ? (20 / 3.6) / acceleration : 0;
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "From 10 to 30",
                style: Theme.of(context).textTheme.title,
              ),
              SevenSegment(acceleration > 0 ? time.toInt().toString() : "0",
                  size: 6),
              Text("Seconds", style: Theme.of(context).textTheme.title),
              Text(
                "From 30 to 10",
                style: Theme.of(context).textTheme.title,
              ),
              SevenSegment(
                  acceleration < 0 ? time.toInt().abs().toString() : "0",
                  size: 6),
              Text("Seconds", style: Theme.of(context).textTheme.title),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connected Car Task"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Current Speed ",
                      style: Theme.of(context).textTheme.title,
                    ),
                    _buildSpeedWidget(),
                    Text(
                      "Kmh",
                      style: Theme.of(context).textTheme.title,
                    ),
                    _buildTimeWidget()
                  ]),
            )));
  }
}
