import 'package:flutter/material.dart';


class AppColors {
  // --- الألوان الأساسية (Red Energy) ---
  // تم اختيار أحمر "روبي" عميق بدلاً من الأحمر التقليدي ليعطي فخامة
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color primaryLight = Color(0xFFFFCDD2);
  static const Color accent = Color(0xFFFF4081);// الأسود الفحمي كـ Accent يعطي هيبة للماركة

  // --- درجات الرمادي الاحترافية (Neutral Slate) ---
  // الدرجات المائلة للأزرق/الرمادي (Slate) تريح العين أكثر من الرمادي الصرف
  static const Color white = Colors.white;
  static const Color black = Color(0xFF0F172A);
  static const Color greyLight = Color(0xFFF1F5F9);
  static const Color greyMedium = Color(0xFFE2E8F0);
  static const Color greyDark = Color(0xFF475569);

  // --- الألوان الوظيفية (Functional) ---
  static const Color success = Color(0xFF10B981); // أخضر زمردي
  static const Color warning = Color(0xFFF59E0B); // برتقالي عنبري
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // --- حالات الطلبات (Order Status) ---
  static const Color pending = Color(0xFFF59E0B);
  static const Color processing = Color(0xFF3B82F6);
  static const Color shipped = Color(0xFF8B5CF6);    // بنفسجي للشحن يعطي تميز
  static const Color delivered = Color(0xFF10B981);
  static const Color cancelled = Color(0xFF64748B);  // رمادي للطلبات المُلغاة

  // --- الخلفيات (Backgrounds) ---
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // --- ألوان النصوص (Typography) ---
  static const Color textDark = Color(0xFF1E293B);   // نص رئيسي غامق جداً
  static const Color textLight = Color(0xFF64748B);  // نص فرعي
  static const Color textMuted = Color(0xFF94A3B8);  // نص باهت/تلميحات

  // --- ألوان المخزون (Inventory) ---
  static const Color inStock = Color(0xFF10B981);
  static const Color lowStock = Color(0xFFF59E0B);
  static const Color outOfStock = Color(0xFFEF4444);
}
class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.textLight,
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
        background: AppColors.backgroundDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF252525),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF444444)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF444444)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF333333),
        thickness: 1,
      ),
    );
  }
}
