import 'package:flutter/material.dart';
import '../theme/theme_ext.dart';

/// Date picker field matching [AppTextField] styling.
///
/// Shows a calendar icon suffix and opens the native date picker on tap.
class AppDateField extends StatelessWidget {
  final String hintText;
  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDateField({
    super.key,
    this.hintText = 'Select Date',
    this.label,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final displayText = value != null
        ? '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/'
            '${value!.year}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textStyles.paragraphSmallRegular.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText ?? hintText,
                    style: displayText != null
                        ? textStyles.paragraphSmallRegular.copyWith(
                            color: colors.foreground,
                          )
                        : textStyles.paragraphSmallRegular.copyWith(
                            color: colors.mutedForeground,
                          ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colors.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 18),
      firstDate: firstDate ?? DateTime(1920),
      lastDate: lastDate ?? now,
    );
    if (picked != null) {
      onChanged?.call(picked);
    }
  }
}
