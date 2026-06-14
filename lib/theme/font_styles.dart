library;

import 'package:flutter/widgets.dart';

/// Raw typography definitions using the Geist font family.
///
/// These are consumed by [AppTextStyles] (the ThemeExtension) and
/// registered on the app-level ThemeData.
abstract class AppTextStyle {
  static const String? _fontPackage = null;

  // ═══════════════════════════════════════════════════════════════
  // HEADINGS
  // ═══════════════════════════════════════════════════════════════

  /// 48px · w600 · height 1.0 · tracking −1.5
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Geist',
    fontSize: 48,
    height: 1,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.5,
    package: _fontPackage,
  );

  /// 30px · w600 · height 1.0 · tracking −1.0
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Geist',
    fontSize: 30,
    height: 1,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    package: _fontPackage,
  );

  /// 24px · w600 · height 1.2 · tracking −1.0
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Geist',
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    package: _fontPackage,
  );

  /// 20px · w600 · height 1.2
  static const TextStyle heading4 = TextStyle(
    fontFamily: 'Geist',
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // SPECIALTY
  // ═══════════════════════════════════════════════════════════════

  /// 16px · w400 · height 1.5 · Geist Mono
  static const TextStyle monospaced = TextStyle(
    fontFamily: 'Geist Mono',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );

  /// 14px · w400 · height 1.5 · tracking 1.5
  static const TextStyle caption = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH LARGE — 18px
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle paragraphLargeRegular = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    height: 1.5,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );

  static const TextStyle paragraphLargeMedium = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    height: 1.5,
    fontWeight: FontWeight.w500,
    package: _fontPackage,
  );

  static const TextStyle paragraphLargeBold = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    height: 1.5,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH — 16px
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle paragraphRegular = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );

  static const TextStyle paragraphMedium = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
    package: _fontPackage,
  );

  static const TextStyle paragraphBold = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH SMALL — 14px
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle paragraphSmallRegular = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );

  static const TextStyle paragraphSmallMedium = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    package: _fontPackage,
  );

  static const TextStyle paragraphSmallBold = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH MINI — 12px
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle paragraphMiniRegular = TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );

  static const TextStyle paragraphMiniMedium = TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    package: _fontPackage,
  );

  static const TextStyle paragraphMiniBold = TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );

  // ═══════════════════════════════════════════════════════════════
  // CAPTION XS — 10px
  // ═══════════════════════════════════════════════════════════════

  static const TextStyle captionXsRegular = TextStyle(
    fontFamily: 'Geist',
    fontSize: 10,
    height: 1.33,
    fontWeight: FontWeight.w500,
    package: _fontPackage,
  );
}
