import 'package:flutter/material.dart';

class FunctionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? tooltip;
  final String? label;
  final VoidCallback? onTap;

  const FunctionIcon({
    super.key,
    required this.icon,
    required this.color,
    this.tooltip,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (tooltip != null) {
      iconWidget = Tooltip(message: tooltip!, child: iconWidget);
    }

    if (onTap != null) {
      iconWidget = GestureDetector(onTap: onTap, child: iconWidget);
    }

    return iconWidget;
  }
}
