import 'package:flutter/material.dart';
import 'dart:math';

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: Colors.deepPurpleAccent,
      inactiveColor: Colors.grey.shade800,
      min: 0.0,
      max: duration.inMilliseconds.toDouble(),
      value: min(position.inMilliseconds.toDouble(), duration.inMilliseconds.toDouble()),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(Duration(milliseconds: value.round()));
        }
      },
      onChangeEnd: (value) {
        if (onChangeEnd != null) {
          onChangeEnd!(Duration(milliseconds: value.round()));
        }
      },
    );
  }
}