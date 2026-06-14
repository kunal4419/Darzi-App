import 'package:flutter/material.dart';
import '../theme/theme_ext.dart';

/// Inline link text pattern: "Some text " + tappable "Link".
///
/// Used for "Already have an account? Login" / "Don't have an account? Signup".
class InlineLinkText extends StatelessWidget {
  final String prefix;
  final String linkText;
  final VoidCallback? onTap;

  const InlineLinkText({
    super.key,
    required this.prefix,
    required this.linkText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: textStyles.paragraphSmallRegular.copyWith(
            color: colors.mutedForeground,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: textStyles.paragraphSmallRegular.copyWith(
              color: colors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
