import 'package:flutter/material.dart';

class IndicatorsModel {
  final String title;
  final String subtitle;
  final String value;
  final Color color;
  final IconData icon;
  final String trend;
  final bool isUp;
  final Color? chartColor;

  IndicatorsModel({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.icon,
    required this.trend,
    required this.isUp,
    this.chartColor,
  });
}
