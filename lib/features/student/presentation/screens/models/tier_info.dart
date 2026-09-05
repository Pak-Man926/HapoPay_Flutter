import 'package:flutter/material.dart';

class TierInfo {
  final String name;
  final int min;
  final int max;
  final Color color;
  final String emoji;

  const TierInfo({
    required this.name,
    required this.min,
    required this.max,
    required this.color,
    required this.emoji,
  });
}
