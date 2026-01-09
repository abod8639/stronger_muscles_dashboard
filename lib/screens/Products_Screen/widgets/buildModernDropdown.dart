import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

// جعلنا الكلاس Generic <T> لكي يتقبل أي نوع من القيم (String, Int, أو حتى Model)
class CustomModernDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final IconData prefixIcon;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomModernDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = 'اختر',
    this.prefixIcon = Icons.category_outlined,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primary.withOpacity(0.7),
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.primary.withOpacity(0.7),
            size: 24,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : AppColors.primary.withOpacity(0.6),
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}