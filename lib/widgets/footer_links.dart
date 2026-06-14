import 'package:flutter/material.dart';
import '../theme/theme_ext.dart';

/// Footer links row (Help | Terms | Privacy) reused across auth screens.
class FooterLinks extends StatelessWidget {
  final VoidCallback? onHelpTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const FooterLinks({
    super.key,
    this.onHelpTap,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _link('Help', colors.mutedForeground, textStyles, onHelpTap),
          const SizedBox(width: 24),
          _link('Terms', colors.mutedForeground, textStyles, onTermsTap),
          const SizedBox(width: 24),
          _link('Privacy', colors.mutedForeground, textStyles, onPrivacyTap),
        ],
      ),
    );
  }

  Widget _link(
    String label,
    Color color,
    dynamic textStyles,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: textStyles.paragraphMiniBold.copyWith(color: color),
      ),
    );
  }
}
