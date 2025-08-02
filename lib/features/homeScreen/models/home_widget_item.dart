import 'package:flutter/material.dart';

// 위젯 아이템 모델
class HomeWidgetItem {
  final String id;
  final String title;
  final String description;
  final IconData? icon;
  final Color color;

  HomeWidgetItem({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    required this.color,
  });
}