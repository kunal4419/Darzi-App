import 'package:flutter/material.dart';

import '../theme/theme_ext.dart';

/// Reusable error widget for consistent error UI across the app.
///
/// Displays an error icon, message text, and a retry button.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? retryButtonText;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colors.mutedForeground,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: textStyles.paragraphRegular.copyWith(
                color: colors.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.primaryForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                retryButtonText ?? 'Retry',
                style: textStyles.paragraphRegular.copyWith(
                  color: colors.primaryForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
