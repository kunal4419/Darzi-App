import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/supabase_service.dart';
import '../core/constants/hindi_strings.dart';

/// GetX controller managing all order state.
///
/// Reactive observables automatically update the UI.
/// Use [Get.find<OrderController>()] to access from any widget.
class OrderController extends GetxController {
  final SupabaseService _service = SupabaseService();

  // ── Observable state ──
  final orders = <OrderModel>[].obs;           // Full list from Supabase
  final filteredOrders = <OrderModel>[].obs;   // List shown after search
  final isLoading = false.obs;                 // Loading orders list
  final isSaving = false.obs;                  // Saving/updating an order
  final searchQuery = ''.obs;                  // Current search text
  final errorMessage = ''.obs;                 // Error to show in UI

  // ── Filters ──
  final selectedFilter = 'all'.obs;            // 'all', 'pending' (baki), 'completed' (pura_hua)
  final selectedDate = Rxn<DateTime>();        // Selected date filter

  // Cached raw search results to filter locally
  final _searchResult = <OrderModel>[];

  // ── Search debounce timer ──
  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();
    loadOrders();

    // Watch search query and debounce
    ever(searchQuery, (_) => _onSearchChanged());

    // Watch filters and apply local updates automatically
    ever(selectedFilter, (_) => applyLocalFilters());
    ever(selectedDate, (_) => applyLocalFilters());
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  // ────────────────────────────────────────────────────────────
  // LOAD
  // ────────────────────────────────────────────────────────────

  /// Fetches all orders from Supabase and populates [orders].
  Future<void> loadOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.getAllOrders();
      orders.value = result;
      _searchResult.clear();
      applyLocalFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ────────────────────────────────────────────────────────────
  // SEARCH
  // ────────────────────────────────────────────────────────────

  /// Called whenever the search field changes.
  /// Debounces by 300ms to avoid excessive Supabase calls.
  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(searchQuery.value);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      _searchResult.clear();
      applyLocalFilters();
      return;
    }

    isLoading.value = true;
    try {
      final result = await _service.searchOrders(query);
      _searchResult.clear();
      _searchResult.addAll(result);
      applyLocalFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Applies all search, payment, and date filters locally to filteredOrders.
  void applyLocalFilters() {
    List<OrderModel> baseList = searchQuery.value.trim().isEmpty
        ? List<OrderModel>.from(orders)
        : List<OrderModel>.from(_searchResult);

    // Apply Payment Filter
    if (selectedFilter.value == 'pending') {
      baseList = baseList.where((o) {
        final pending = o.pendingAmount ?? o.localPendingAmount;
        return pending > 0;
      }).toList();
    } else if (selectedFilter.value == 'completed') {
      baseList = baseList.where((o) {
        final pending = o.pendingAmount ?? o.localPendingAmount;
        return pending <= 0;
      }).toList();
    }

    // Apply Date Filter
    if (selectedDate.value != null) {
      final target = selectedDate.value!;
      baseList = baseList.where((o) {
        final date = o.createdAt;
        return date.year == target.year &&
            date.month == target.month &&
            date.day == target.day;
      }).toList();
    }

    filteredOrders.value = baseList;
  }

  // ────────────────────────────────────────────────────────────
  // ADD ORDER
  // ────────────────────────────────────────────────────────────

  /// Inserts a new order into Supabase.
  /// Shows GetX snackbar on success or failure.
  Future<bool> addOrder(OrderModel order) async {
    isSaving.value = true;
    try {
      final saved = await _service.insertOrder(order);
      orders.insert(0, saved); // Add to top of list
      if (searchQuery.value.trim().isNotEmpty) {
        _searchResult.insert(0, saved);
      }
      applyLocalFilters();
      _showSuccess(HindiStrings.orderSaved);
      return true;
    } catch (e) {
      _showError(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ────────────────────────────────────────────────────────────
  // UPDATE ORDER
  // ────────────────────────────────────────────────────────────

  /// Updates an existing order in Supabase.
  Future<bool> updateOrder(OrderModel order) async {
    isSaving.value = true;
    try {
      final updated = await _service.updateOrder(order);

      // Replace in local lists
      final idx = orders.indexWhere((o) => o.id == order.id);
      if (idx != -1) orders[idx] = updated;

      final sIdx = _searchResult.indexWhere((o) => o.id == order.id);
      if (sIdx != -1) _searchResult[sIdx] = updated;

      applyLocalFilters();
      _showSuccess(HindiStrings.orderUpdated);
      return true;
    } catch (e) {
      _showError(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ────────────────────────────────────────────────────────────
  // DELETE ORDER
  // ────────────────────────────────────────────────────────────

  /// Deletes an order from Supabase and removes it from local lists.
  Future<bool> deleteOrder(String id) async {
    try {
      await _service.deleteOrder(id);
      orders.removeWhere((o) => o.id == id);
      _searchResult.removeWhere((o) => o.id == id);
      applyLocalFilters();
      _showSuccess(HindiStrings.orderDeleted);
      return true;
    } catch (e) {
      _showError(e.toString());
      return false;
    }
  }

  // ────────────────────────────────────────────────────────────
  // Snackbar helpers
  // ────────────────────────────────────────────────────────────

  void _showSuccess(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2E7D32), // DarziColors.success
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'गड़बड़ी',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC62828), // DarziColors.error
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }
}
