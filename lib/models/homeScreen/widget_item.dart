import 'package:flutter/material.dart';

// 위젯 아이템 모델
class WidgetItem {
  final String id;
  final String title;
  final String description;
  final IconData? icon;
  final Color color;

  WidgetItem({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    required this.color,
  });
}