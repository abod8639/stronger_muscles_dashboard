import 'package:flutter/material.dart';

Widget buildDetailRow(
  IconData icon,
  String label,
  String value, {
  Widget? trailing,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),

        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child:
                trailing ??
                SelectionArea(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
          ),
        ),
      ],
    ),
  );
}
