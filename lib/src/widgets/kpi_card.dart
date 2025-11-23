import 'package:flutter/material.dart';

class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? subtitle2;
  final Color? valueColor;
  final Color? subtitleColor;
  final Color? subtitle2Color;
  final IconData? icon;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.subtitle2,
    this.valueColor,
    this.subtitleColor,
    this.subtitle2Color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 14, color: Colors.grey[400]),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: subtitleColor ?? Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (subtitle2 != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle2!,
              style: TextStyle(
                fontSize: 12,
                color: subtitle2Color ?? Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
