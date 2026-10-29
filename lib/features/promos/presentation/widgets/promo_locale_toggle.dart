import 'package:flutter/material.dart';

/// مبدّل لغة معاينة الإعلان (عربي / EN)
class PromoLocaleToggle extends StatelessWidget {
  final String locale;
  final ValueChanged<String> onChanged;

  const PromoLocaleToggle({
    super.key,
    required this.locale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: const [
        ButtonSegment(value: 'ar', label: Text('عربي')),
        ButtonSegment(value: 'en', label: Text('EN')),
      ],
      selected: {locale},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}
