/// Application-wide constants for Darzi App.
class AppConstants {
  AppConstants._();

  // ── Branding ──
  static const String appName = 'Rakhi Tailors';
  static const String appTagline = 'सिलाई के लिए';

  // ── Animation ──
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // ── Layout ──
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;
  static const double cardPadding = 12.0;
  static const double buttonHeight = 56.0; // Large touch target
  static const double fieldHeight = 56.0;  // Min field height per UI/UX spec
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;

  // ── Search debounce ──
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // ── Cloth types ──
  static const List<String> clothTypes = [
    'ब्लाउज',
    'साड़ी',
    'ड्रेस',
    'फ्रॉक',
  ];
}
