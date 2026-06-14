import 'package:flutter/material.dart';
import '../core/constants/darzi_colors.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Central theme configuration for Darzi App.
///
/// Uses DarziColors (blue/green palette from UI/UX Guidelines).
/// AppColors and AppTextStyles ThemeExtensions are kept for reusable widgets.
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: DarziColors.primary,
      onPrimary: DarziColors.primaryForeground,
      primaryContainer: Color(0xFFBBDEFB),
      onPrimaryContainer: Color(0xFF0D47A1),
      secondary: DarziColors.success,
      onSecondary: DarziColors.primaryForeground,
      tertiary: DarziColors.warning,
      onTertiary: DarziColors.primaryForeground,
      error: DarziColors.error,
      onError: DarziColors.primaryForeground,
      surface: DarziColors.surface,
      onSurface: DarziColors.textDark,
      surfaceContainerHighest: DarziColors.surface,
      onSurfaceVariant: DarziColors.textGray,
      outline: DarziColors.divider,
    ),
    scaffoldBackgroundColor: DarziColors.background,

    // ── AppBar ──
    appBarTheme: const AppBarTheme(
      backgroundColor: DarziColors.primary,
      foregroundColor: DarziColors.primaryForeground,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: DarziColors.primaryForeground,
      ),
    ),

    // ── Bottom Navigation ──
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DarziColors.surface,
      selectedItemColor: DarziColors.primary,
      unselectedItemColor: DarziColors.textGray,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      elevation: 8,
    ),

    // ── Elevated Button (Save button) ──
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarziColors.primary,
        foregroundColor: DarziColors.primaryForeground,
        minimumSize: const Size(double.infinity, 56), // Large touch target
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // ── Outlined Button (Clear button) ──
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarziColors.textDark,
        side: const BorderSide(color: DarziColors.divider, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Input fields ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarziColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarziColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarziColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarziColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarziColors.error),
      ),
      hintStyle: const TextStyle(color: DarziColors.textGray, fontSize: 15),
      labelStyle: const TextStyle(
        color: DarziColors.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),

    // ── Card ──
    cardTheme: CardThemeData(
      color: DarziColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // ── Chip ──
    chipTheme: ChipThemeData(
      selectedColor: DarziColors.primary,
      backgroundColor: DarziColors.background,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: DarziColors.divider),
      ),
    ),

    // ── Snackbar ──
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DarziColors.textDark,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Text ──
    textTheme: TextTheme(
      displayLarge: AppTextStyles.light.heading1.copyWith(
        color: DarziColors.textDark,
      ),
      displayMedium: AppTextStyles.light.heading2.copyWith(
        color: DarziColors.textDark,
      ),
      headlineLarge: AppTextStyles.light.heading4.copyWith(
        color: DarziColors.textDark,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        color: DarziColors.textDark,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: DarziColors.textDark,
      ),
      labelSmall: const TextStyle(
        fontSize: 12,
        color: DarziColors.textGray,
      ),
    ),

    extensions: const <ThemeExtension>[
      AppColors.light,
      AppTextStyles.light,
    ],
  );
}
