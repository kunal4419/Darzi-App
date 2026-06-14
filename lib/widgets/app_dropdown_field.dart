import 'package:flutter/material.dart';
import '../theme/theme_ext.dart';

/// Modern, minimal dropdown field.
///
/// Tapping opens a styled bottom sheet with options.
/// Accepts a flat list of [items] and an optional [itemLabel] builder.
class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final String? label;
  final List<T> items;
  final String Function(T)? itemLabel;
  final ValueChanged<T?>? onChanged;

  const AppDropdownField({
    super.key,
    this.value,
    required this.hintText,
    this.label,
    required this.items,
    this.itemLabel,
    this.onChanged,
  });

  String _label(T item) => itemLabel?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final hasValue = value != null;
    final displayText = hasValue ? _label(value as T) : hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textStyles.paragraphSmallRegular.copyWith(
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: hasValue
                        ? textStyles.paragraphSmallRegular.copyWith(
                            color: colors.foreground,
                          )
                        : textStyles.paragraphSmallRegular.copyWith(
                            color: colors.mutedForeground,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: colors.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.45,
          ),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ──
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // ── Title ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  hintText,
                  style: textStyles.paragraphBold.copyWith(
                    color: colors.foreground,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                color: colors.border.withValues(alpha: 0.4),
              ),

              // ── Options list ──
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final isSelected = item == value;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        onChanged?.call(item);
                      },
                      splashColor: colors.primary.withValues(alpha: 0.06),
                      highlightColor: colors.primary.withValues(alpha: 0.04),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.06)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _label(item),
                                style: textStyles.paragraphSmallRegular.copyWith(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.foreground,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: colors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
            ],
          ),
        );
      },
    );
  }
}
