import 'package:flutter/material.dart';
import 'color_tokens.dart' as ct;
import 'primitive_colors.dart' as p;

/// Application color palette as a [ThemeExtension].
///
/// All colors are sourced from the design token system.
/// Access via `context.colors` (see [theme_ext.dart]).
class AppColors extends ThemeExtension<AppColors> {
  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME STATIC CONSTANTS
  // ═══════════════════════════════════════════════════════════════

  static const Color lBackground            = ct.background;
  static const Color lForeground            = ct.foreground;
  static const Color lPrimary               = ct.primary;
  static const Color lPrimaryForeground     = ct.primaryForeground;
  static const Color lSecondary             = ct.secondary;
  static const Color lSecondaryForeground   = ct.secondaryForeground;
  static const Color lAccent                = ct.accent;
  static const Color lAccentForeground      = ct.accentForeground;
  static const Color lMuted                 = ct.muted;
  static const Color lMutedForeground       = ct.mutedForeground;
  static const Color lDestructive           = ct.destructive;
  static const Color lDestructiveForeground = ct.destructiveForeground;
  static const Color lBorder                = ct.border;
  static const Color lInput                 = ct.input;
  static const Color lCard                  = ct.card;
  static const Color lCardForeground        = ct.cardForeground;
  static const Color lBodyBackground        = ct.bodyBackground;
  static const Color lRing                  = ct.ring;
  static const Color lIconBackground        = p.sky200;

  // ═══════════════════════════════════════════════════════════════
  // THEME EXTENSION FIELDS
  // ═══════════════════════════════════════════════════════════════

  final Color background;
  final Color foreground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color accent;
  final Color accentForeground;
  final Color muted;
  final Color mutedForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color card;
  final Color cardForeground;
  final Color bodyBackground;
  final Color ring;
  final Color iconBackground;

  const AppColors({
    required this.background,
    required this.foreground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.accent,
    required this.accentForeground,
    required this.muted,
    required this.mutedForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.card,
    required this.cardForeground,
    required this.bodyBackground,
    required this.ring,
    required this.iconBackground,
  });

  static const light = AppColors(
    background:            lBackground,
    foreground:            lForeground,
    primary:               lPrimary,
    primaryForeground:     lPrimaryForeground,
    secondary:             lSecondary,
    secondaryForeground:   lSecondaryForeground,
    accent:                lAccent,
    accentForeground:      lAccentForeground,
    muted:                 lMuted,
    mutedForeground:       lMutedForeground,
    destructive:           lDestructive,
    destructiveForeground: lDestructiveForeground,
    border:                lBorder,
    input:                 lInput,
    card:                  lCard,
    cardForeground:        lCardForeground,
    bodyBackground:        lBodyBackground,
    ring:                  lRing,
    iconBackground:        lIconBackground,
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? foreground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? accent,
    Color? accentForeground,
    Color? muted,
    Color? mutedForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? card,
    Color? cardForeground,
    Color? bodyBackground,
    Color? ring,
    Color? iconBackground,
  }) {
    return AppColors(
      background:            background            ?? this.background,
      foreground:            foreground            ?? this.foreground,
      primary:               primary               ?? this.primary,
      primaryForeground:     primaryForeground     ?? this.primaryForeground,
      secondary:             secondary             ?? this.secondary,
      secondaryForeground:   secondaryForeground   ?? this.secondaryForeground,
      accent:                accent                ?? this.accent,
      accentForeground:      accentForeground      ?? this.accentForeground,
      muted:                 muted                 ?? this.muted,
      mutedForeground:       mutedForeground       ?? this.mutedForeground,
      destructive:           destructive           ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      border:                border                ?? this.border,
      input:                 input                 ?? this.input,
      card:                  card                  ?? this.card,
      cardForeground:        cardForeground        ?? this.cardForeground,
      bodyBackground:        bodyBackground        ?? this.bodyBackground,
      ring:                  ring                  ?? this.ring,
      iconBackground:        iconBackground        ?? this.iconBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background:            Color.lerp(background,            other.background,            t)!,
      foreground:            Color.lerp(foreground,            other.foreground,            t)!,
      primary:               Color.lerp(primary,               other.primary,               t)!,
      primaryForeground:     Color.lerp(primaryForeground,     other.primaryForeground,     t)!,
      secondary:             Color.lerp(secondary,             other.secondary,             t)!,
      secondaryForeground:   Color.lerp(secondaryForeground,   other.secondaryForeground,   t)!,
      accent:                Color.lerp(accent,                other.accent,                t)!,
      accentForeground:      Color.lerp(accentForeground,      other.accentForeground,      t)!,
      muted:                 Color.lerp(muted,                 other.muted,                 t)!,
      mutedForeground:       Color.lerp(mutedForeground,       other.mutedForeground,       t)!,
      destructive:           Color.lerp(destructive,           other.destructive,           t)!,
      destructiveForeground: Color.lerp(destructiveForeground, other.destructiveForeground, t)!,
      border:                Color.lerp(border,                other.border,                t)!,
      input:                 Color.lerp(input,                 other.input,                 t)!,
      card:                  Color.lerp(card,                  other.card,                  t)!,
      cardForeground:        Color.lerp(cardForeground,        other.cardForeground,        t)!,
      bodyBackground:        Color.lerp(bodyBackground,        other.bodyBackground,        t)!,
      ring:                  Color.lerp(ring,                  other.ring,                  t)!,
      iconBackground:        Color.lerp(iconBackground,        other.iconBackground,        t)!,
    );
  }
}
