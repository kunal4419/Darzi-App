import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/darzi_colors.dart';

/// Quick-select cloth type chips.
///
/// Displays a Wrap of tappable chips for the user to select cloth type.
/// Much faster than typing — optimized for semi-literate users.
/// Only one chip can be selected at a time.
///
/// Usage:
/// ```dart
/// ClothTypeChips(
///   selected: _selectedClothType,
///   onSelected: (type) => setState(() => _selectedClothType = type),
/// )
/// ```
class ClothTypeChips extends StatelessWidget {
  final String? selected;
  final void Function(String?) onSelected;

  const ClothTypeChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.clothTypes.map((type) {
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () {
            // Tap again to deselect
            onSelected(isSelected ? null : type);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? DarziColors.primary : DarziColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? DarziColors.primary : DarziColors.divider,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: DarziColors.primary.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? DarziColors.primaryForeground
                    : DarziColors.textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
