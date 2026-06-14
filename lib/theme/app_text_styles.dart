import 'package:flutter/material.dart';
import 'font_styles.dart';

/// Application typography system as a [ThemeExtension].
///
/// All styles use the **Geist** font family (monospaced uses Geist Mono).
/// Access via `context.textStyles` (see [theme_ext.dart]).
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles._();

  static const light = AppTextStyles._();

  @override
  AppTextStyles copyWith() => this;

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) => this;

  // ═══════════════════════════════════════════════════════════════
  // HEADINGS
  // ═══════════════════════════════════════════════════════════════

  /// 48px · w600 · height 1.0 · tracking −1.5
  TextStyle get heading1 => AppTextStyle.heading1;

  /// 30px · w600 · height 1.0 · tracking −1.0
  TextStyle get heading2 => AppTextStyle.heading2;

  /// 24px · w600 · height 1.2 · tracking −1.0
  TextStyle get heading3 => AppTextStyle.heading3;

  /// 20px · w600 · height 1.2
  TextStyle get heading4 => AppTextStyle.heading4;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALTY
  // ═══════════════════════════════════════════════════════════════

  /// 16px · w400 · height 1.5 · Geist Mono
  TextStyle get monospaced => AppTextStyle.monospaced;

  /// 14px · w400 · height 1.5 · tracking 1.5
  TextStyle get caption => AppTextStyle.caption;

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH LARGE — 18px
  // ═══════════════════════════════════════════════════════════════

  TextStyle get paragraphLargeRegular => AppTextStyle.paragraphLargeRegular;
  TextStyle get paragraphLargeMedium  => AppTextStyle.paragraphLargeMedium;
  TextStyle get paragraphLargeBold    => AppTextStyle.paragraphLargeBold;

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH — 16px
  // ═══════════════════════════════════════════════════════════════

  TextStyle get paragraphRegular => AppTextStyle.paragraphRegular;
  TextStyle get paragraphMedium  => AppTextStyle.paragraphMedium;
  TextStyle get paragraphBold    => AppTextStyle.paragraphBold;

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH SMALL — 14px
  // ═══════════════════════════════════════════════════════════════

  TextStyle get paragraphSmallRegular => AppTextStyle.paragraphSmallRegular;
  TextStyle get paragraphSmallMedium  => AppTextStyle.paragraphSmallMedium;
  TextStyle get paragraphSmallBold    => AppTextStyle.paragraphSmallBold;

  // ═══════════════════════════════════════════════════════════════
  // PARAGRAPH MINI — 12px
  // ═══════════════════════════════════════════════════════════════

  TextStyle get paragraphMiniRegular => AppTextStyle.paragraphMiniRegular;
  TextStyle get paragraphMiniMedium  => AppTextStyle.paragraphMiniMedium;
  TextStyle get paragraphMiniBold    => AppTextStyle.paragraphMiniBold;

  TextStyle get captionXsRegular => AppTextStyle.captionXsRegular;
}
