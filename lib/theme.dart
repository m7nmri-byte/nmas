import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// نظام تصميم موحّد للتطبيق: لوحة ألوان داكنة أنيقة + طباعة عربية عصرية.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF131A2E);
  static const Color surfaceRaised = Color(0xFF1B2440);
  static const Color surfaceHighlight = Color(0xFF232D4E);
  static const Color outline = Color(0xFF2A3355);

  static const Color gold = Color(0xFFE3A94A);
  static const Color goldSoft = Color(0xFF3A2F17);
  static const Color emerald = Color(0xFF35C98A);
  static const Color emeraldSoft = Color(0xFF123526);
  static const Color rose = Color(0xFFE8677A);

  static const Color textPrimary = Color(0xFFF3F1EA);
  static const Color textMuted = Color(0xFFA1A9C2);
  static const Color textFaint = Color(0xFF6B7395);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.gold,
        onPrimary: Color(0xFF241A05),
        primaryContainer: AppColors.goldSoft,
        onPrimaryContainer: AppColors.gold,
        secondary: AppColors.emerald,
        onSecondary: Color(0xFF06251A),
        secondaryContainer: AppColors.emeraldSoft,
        onSecondaryContainer: AppColors.emerald,
        tertiary: AppColors.rose,
        error: AppColors.rose,
        onSurface: AppColors.textPrimary,
        outline: AppColors.outline,
        surfaceContainerHighest: AppColors.surfaceHighlight,
      ),
    );

    final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.tajawal(
          fontSize: 46, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
      displayMedium: GoogleFonts.tajawal(
          fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.tajawal(
          fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineSmall: GoogleFonts.tajawal(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleLarge: GoogleFonts.tajawal(
          fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: GoogleFonts.tajawal(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleSmall: GoogleFonts.tajawal(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMuted),
      bodyLarge: GoogleFonts.tajawal(fontSize: 15, color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.tajawal(fontSize: 14, color: AppColors.textMuted),
      bodySmall: GoogleFonts.tajawal(fontSize: 12.5, color: AppColors.textFaint),
      labelLarge: GoogleFonts.tajawal(
          fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.4),
      labelMedium: GoogleFonts.tajawal(
          fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textFaint, letterSpacing: 0.4),
      labelSmall: GoogleFonts.tajawal(
          fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textFaint, letterSpacing: 0.4),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.outline, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.6),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: const Color(0xFF241A05),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textMuted),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF241A05),
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w700, fontSize: 13.5),
        unselectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 13.5),
        indicator: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: Color(0xFF241A05),
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.textMuted),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.surfaceHighlight,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent,
        ),
      ),
    );
  }

  /// خط تقني بأرقام متساوية العرض، مخصص للساعة والعدّادات التنازلية.
  static TextStyle mono({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
