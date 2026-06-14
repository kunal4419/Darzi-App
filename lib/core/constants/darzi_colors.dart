import 'package:flutter/material.dart';

/// Darzi App color palette.
///
/// Based on the UI/UX Guidelines:
/// Primary Blue   #1E88E5 — AppBar, Save button, active tab
/// Success Green  #2E7D32 — Success messages, confirm
/// Warning Amber  #F57F17 — Pending payment, alerts
/// Error Red      #C62828 — Validation errors
/// Background     #F5F5F5 — App background
/// Surface White  #FFFFFF — Cards, inputs
/// Text Dark      #212121 — Primary text
/// Text Gray      #757575 — Placeholder / helper text
class DarziColors {
  DarziColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF1E88E5);       // Blue — save, active tab
  static const Color primaryDark = Color(0xFF1565C0);   // Darker blue — pressed state
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // ── Success ──
  static const Color success = Color(0xFF2E7D32);       // Green
  static const Color successLight = Color(0xFFE8F5E9);  // Green background

  // ── Warning / Pending ──
  static const Color warning = Color(0xFFF57F17);       // Amber — pending amount
  static const Color warningLight = Color(0xFFFFF3E0);  // Amber background

  // ── Error ──
  static const Color error = Color(0xFFC62828);         // Red
  static const Color errorLight = Color(0xFFFFEBEE);    // Red background

  // ── Backgrounds ──
  static const Color background = Color(0xFFF5F5F5);    // App bg (warm gray)
  static const Color surface = Color(0xFFFFFFFF);       // Cards, inputs
  static const Color divider = Color(0xFFE0E0E0);       // Dividers, borders

  // ── Text ──
  static const Color textDark = Color(0xFF212121);      // Primary text
  static const Color textGray = Color(0xFF757575);      // Placeholder, helper
  static const Color textLight = Color(0xFFBDBDBD);     // Disabled text

  // ── Status chips ──
  static const Color statusPending = Color(0xFFFFF3E0);
  static const Color statusPendingText = Color(0xFFE65100);
  static const Color statusReady = Color(0xFFE8F5E9);
  static const Color statusReadyText = Color(0xFF1B5E20);
  static const Color statusDelivered = Color(0xFFE3F2FD);
  static const Color statusDeliveredText = Color(0xFF0D47A1);
}
