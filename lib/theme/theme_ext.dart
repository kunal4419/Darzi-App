import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Convenience [BuildContext] extensions for quick theme access.
///
/// ```dart
/// final primary = context.colors.primary;
/// final style  = context.textStyles.bodyRegular;
/// ```
extension ThemeExtensionBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  AppColors get colors => theme.extension<AppColors>() ?? AppColors.light;
  AppTextStyles get textStyles =>
      theme.extension<AppTextStyles>() ?? AppTextStyles.light;
}
