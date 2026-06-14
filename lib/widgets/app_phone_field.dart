import 'package:flutter/material.dart';
import '../theme/theme_ext.dart';

/// Phone number field with a country code prefix (+91 ▾).
///
/// Matches [AppTextField] styling with an inline prefix selector.
class AppPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String countryCode;
  final VoidCallback? onCountryCodeTap;
  final void Function(String)? onChanged;

  const AppPhoneField({
    super.key,
    this.controller,
    this.hintText = 'Phone no',
    this.countryCode = '+91',
    this.onCountryCodeTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Country code selector
          GestureDetector(
            onTap: onCountryCodeTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: textStyles.paragraphSmallRegular.copyWith(
                      color: colors.foreground,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: colors.mutedForeground,
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 24,
            width: 1,
            color: colors.border.withValues(alpha: 0.5),
          ),

          // Phone input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: onChanged,
              style: textStyles.paragraphSmallRegular.copyWith(
                color: colors.foreground,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textStyles.paragraphSmallRegular.copyWith(
                  color: colors.mutedForeground,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
