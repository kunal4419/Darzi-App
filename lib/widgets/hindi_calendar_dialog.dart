import 'package:flutter/material.dart';
import '../core/constants/darzi_colors.dart';

/// A clean, custom Hindi calendar dialog.
///
/// Features:
/// - Fully in Hindi (months & weekdays).
/// - Sunday column (holidays) highlighted in light red.
/// - Left-right swippable month navigation using PageView.
/// - Clickable chevron arrows for quick month change.
/// - Select option returns the chosen date.
class HindiCalendarDialog extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const HindiCalendarDialog({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<HindiCalendarDialog> createState() => _HindiCalendarDialogState();
}

class _HindiCalendarDialogState extends State<HindiCalendarDialog> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;
  late PageController _pageController;

  static const List<String> _hindiMonths = [
    'जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
    'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
  ];

  static const List<String> _hindiWeekdays = [
    'रवि', 'सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि'
  ];

  // Base page calculation starting at Year 2020
  static const int _baseYear = 2020;
  
  int _getPageIndex(DateTime date) {
    return (date.year - _baseYear) * 12 + date.month - 1;
  }

  DateTime _getMonthFromIndex(int index) {
    final year = _baseYear + (index ~/ 12);
    final month = (index % 12) + 1;
    return DateTime(year, month, 1);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    
    final initialPage = _getPageIndex(_focusedMonth);
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _focusedMonth = _getMonthFromIndex(index);
    });
  }

  void _nextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = _focusedMonth.year;
    final currentMonthName = _hindiMonths[_focusedMonth.month - 1];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: DarziColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header (Arrows + Month/Year) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: DarziColors.textDark),
                  onPressed: _prevMonth,
                ),
                Text(
                  '$currentMonthName $currentYear',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DarziColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: DarziColors.textDark),
                  onPressed: _nextMonth,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Weekdays row (Starting Sunday) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _hindiWeekdays.asMap().entries.map((entry) {
                final idx = entry.key;
                final day = entry.value;
                final isSunday = idx == 0;
                return SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSunday ? const Color(0xFFC62828) : DarziColors.textGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, color: DarziColors.divider),
            const SizedBox(height: 8),

            // ── Calendar Pages ──
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final monthDate = _getMonthFromIndex(index);
                  return _buildCalendarGrid(monthDate);
                },
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: DarziColors.divider),
            const SizedBox(height: 14),

            // ── Action Buttons ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'बंद करें',
                    style: TextStyle(color: DarziColors.textGray, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onDateSelected(_selectedDate);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DarziColors.primary,
                    minimumSize: const Size(80, 40), // Override global double.infinity width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text(
                    'चुनें',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime monthDate) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstDayOfWeekday = DateTime(monthDate.year, monthDate.month, 1).weekday; // Mon=1, Sun=7

    // Offset Sunday to column index 0 (Sun=0, Mon=1, Tue=2... Sat=6)
    final firstDayOffset = firstDayOfWeekday == 7 ? 0 : firstDayOfWeekday;

    final totalCells = firstDayOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final gridCellCount = rowCount * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: gridCellCount,
      itemBuilder: (context, index) {
        if (index < firstDayOffset || index >= firstDayOffset + daysInMonth) {
          // Empty offset cell
          return const SizedBox.shrink();
        }

        final dayNumber = index - firstDayOffset + 1;
        final cellDate = DateTime(monthDate.year, monthDate.month, dayNumber);
        
        final isSelected = _selectedDate.year == cellDate.year &&
            _selectedDate.month == cellDate.month &&
            _selectedDate.day == cellDate.day;

        final now = DateTime.now();
        final isToday = now.year == cellDate.year &&
            now.month == cellDate.month &&
            now.day == cellDate.day;

        final isSunday = (index % 7) == 0;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = cellDate;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? DarziColors.primary
                  : isSunday
                      ? const Color(0xFFFFEBEE) // Holiday (Sunday) light red background
                      : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: DarziColors.primary, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isSunday
                        ? const Color(0xFFC62828) // Holiday Sunday red text
                        : DarziColors.textDark,
              ),
            ),
          ),
        );
      },
    );
  }
}
