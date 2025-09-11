import 'package:flutter/material.dart';

class FunctionItem {
  final String id;
  final IconData icon;
  final Color color;
  final String tooltip;
  final String label;
  final VoidCallback onTap;

  FunctionItem({
    required this.id,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.label,
    required this.onTap,
  });
}