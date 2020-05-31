import 'package:flutter/material.dart';
import 'package:segment_display/segment_display.dart';

class SevenSegment extends StatelessWidget {
  final String _value;
  double size;
  SevenSegment(this._value, {this.size});

  @override
  Widget build(BuildContext context) {
    return SevenSegmentDisplay(
        value: _value,
        size: size,
        characterSpacing: 10.0,
        backgroundColor: Colors.transparent,
        segmentStyle: HexSegmentStyle(
          enabledColor: Colors.green,
          disabledColor: Colors.white.withOpacity(0.15),
        ));
  }
}
