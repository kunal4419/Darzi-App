import 'package:flutter/material.dart';

/// Responsive utility helpers.
///
/// Usage:
/// ```dart
/// final isSmall = Responsive.isSmallScreen(context);
/// final padding = Responsive.horizontalPadding(context);
/// ```
class Responsive {
  Responsive._();

  // ── Breakpoints ──
  static const double _smallBreakpoint = 360;
  static const double _mediumBreakpoint = 400;
  static const double _largeBreakpoint = 600;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isSmallScreen(BuildContext context) =>
      screenWidth(context) < _smallBreakpoint;

  static bool isMediumScreen(BuildContext context) =>
      screenWidth(context) >= _smallBreakpoint &&
      screenWidth(context) < _largeBreakpoint;

  static bool isLargeScreen(BuildContext context) =>
      screenWidth(context) >= _largeBreakpoint;

  /// Returns horizontal padding that scales with screen size.
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < _smallBreakpoint) return 16.0;
    if (width < _mediumBreakpoint) return 20.0;
    return 24.0;
  }

  /// Scale a value relative to a 375px design width.
  static double scaleWidth(BuildContext context, double value) {
    return value * screenWidth(context) / 375;
  }

  /// Scale a value relative to an 812px design height.
  static double scaleHeight(BuildContext context, double value) {
    return value * screenHeight(context) / 812;
  }

  /// Scale font size to prevent text overflow on small screens.
  static double scaleFontSize(BuildContext context, double fontSize) {
    final width = screenWidth(context);
    if (width < _smallBreakpoint) return fontSize * 0.85;
    if (width < _mediumBreakpoint) return fontSize * 0.92;
    return fontSize;
  }
}
