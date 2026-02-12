import 'package:flutter/material.dart';

Widget buildDetailRow(
  IconData icon,
  String label,
  String value, {
  Widget? trailing,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),

        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        if (trailing != null)
          trailing
        else
          SelectionArea(
            // يسمح بتحديد أي نص داخله
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    ),
  );
}
