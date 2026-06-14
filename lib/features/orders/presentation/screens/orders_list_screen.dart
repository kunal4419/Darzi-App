import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../core/constants/hindi_strings.dart';
import '../../../../core/constants/darzi_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/order_model.dart';
import '../../../../widgets/order_card.dart';
import '../../../../widgets/voice_input_field.dart';
import '../../../../widgets/hindi_calendar_dialog.dart';
import 'order_detail_bottom_sheet.dart';

/// Screen displaying all saved orders with search capability.
///
/// Features:
/// - Voice + keyboard search bar at top (always visible)
/// - Real-time search with 300ms debounce via OrderController
/// - Pull-to-refresh
/// - Empty state with helpful Hindi message
/// - Error state with retry button
/// - Tap any card to open full detail bottom sheet
class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final _controller = Get.find<OrderController>();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load orders when screen is first shown
    _controller.loadOrders();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _controller.updateSearch(value);
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _controller.updateSearch('');
  }

  void _openOrderDetail(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderDetailBottomSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarziColors.background,
      appBar: AppBar(
        title: const Text(HindiStrings.ordersListTitle),
        actions: [
          // Order count badge
          Obx(() {
            final count = _controller.filteredOrders.length;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count ऑर्डर',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          _buildSearchBar(),

          // ── Filter Chips Bar ──
          _buildFilterChipsBar(),

          // ── Orders List ──
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: DarziColors.primary,
                  ),
                );
              }

              if (_controller.errorMessage.isNotEmpty) {
                return _buildErrorState();
              }

              if (_controller.filteredOrders.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: DarziColors.primary,
                onRefresh: _controller.loadOrders,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: _controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _controller.filteredOrders[index];
                    return OrderCard(
                      order: order,
                      onTap: () => _openOrderDetail(context, order),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      color: DarziColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: VoiceInputField(
        controller: _searchCtrl,
        label: '',
        hint: HindiStrings.searchHint,
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _controller.searchQuery.value.isNotEmpty;

    return RefreshIndicator(
      color: DarziColors.primary,
      onRefresh: _controller.loadOrders,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSearching ? Icons.search_off : Icons.assignment_outlined,
                  size: 70,
                  color: DarziColors.textGray.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  isSearching
                      ? '"${_controller.searchQuery.value}" — कोई ऑर्डर नहीं मिला'
                      : HindiStrings.noOrdersFound,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: DarziColors.textGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (!isSearching)
                  const Text(
                    HindiStrings.noOrdersSubtext,
                    style: TextStyle(
                      fontSize: 14,
                      color: DarziColors.textGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (isSearching) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.clear),
                    label: const Text('खोज साफ़ करें'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: DarziColors.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage.value,
              style: const TextStyle(
                fontSize: 16,
                color: DarziColors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _controller.loadOrders,
              icon: const Icon(Icons.refresh),
              label: const Text(HindiStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipsBar() {
    return Container(
      width: double.infinity,
      color: DarziColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Obx(() {
        final currentFilter = _controller.selectedFilter.value;
        final selectedDate = _controller.selectedDate.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterChip(
                      label: HindiStrings.filterAll,
                      isSelected: currentFilter == 'all' && selectedDate == null,
                      onTap: () {
                        _controller.selectedFilter.value = 'all';
                        _controller.selectedDate.value = null;
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: HindiStrings.filterBaki,
                      isSelected: currentFilter == 'pending',
                      onTap: () {
                        _controller.selectedFilter.value = 'pending';
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: HindiStrings.filterPuraHua,
                      isSelected: currentFilter == 'completed',
                      onTap: () {
                        _controller.selectedFilter.value = 'completed';
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildDateFilterChip(selectedDate),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : DarziColors.textDark,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: DarziColors.primary,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? DarziColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildDateFilterChip(DateTime? selectedDate) {
    final hasDate = selectedDate != null;
    final label = hasDate 
        ? DateFormat('d MMM yyyy').format(selectedDate) 
        : HindiStrings.filterDate;

    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month,
            size: 16,
            color: hasDate ? Colors.white : DarziColors.textDark,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: hasDate ? Colors.white : DarziColors.textDark,
            ),
          ),
        ],
      ),
      selected: hasDate,
      onSelected: (_) => _showCalendarDialog(),
      selectedColor: DarziColors.primary,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      showCheckmark: false,
      onDeleted: hasDate ? () {
        _controller.selectedDate.value = null;
      } : null,
      deleteIconColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: hasDate ? DarziColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (ctx) => HindiCalendarDialog(
        initialDate: _controller.selectedDate.value,
        onDateSelected: (date) {
          _controller.selectedDate.value = date;
        },
      ),
    );
  }
}
