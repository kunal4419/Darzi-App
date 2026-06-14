import 'dart:convert';
import 'cloth_item.dart';

/// Data model for a customer order.
///
/// Matches the Supabase schema representing:
/// - A customer in `customers`
/// - An order in `orders`
/// - Stitching garments in `order_clothes`
class OrderModel {
  final String id;
  final String? customerId;
  final String customerName;
  final String? phoneNumber;
  final double advancePayment;
  final double totalBill;
  final double? pendingAmount;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveryDate;
  final List<ClothItem> clothes;

  const OrderModel({
    required this.id,
    this.customerId,
    required this.customerName,
    this.phoneNumber,
    this.advancePayment = 0.0,
    this.totalBill = 0.0,
    this.pendingAmount,
    this.status = 'pending',
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.deliveryDate,
    this.clothes = const [],
  });

  /// Getter for comma-separated list of cloth types (for backward compatibility).
  String? get clothType => clothes.map((c) => c.clothType).join(', ');

  /// Getter for JSON representation of cloth items (for backward compatibility).
  String? get measurements => jsonEncode(clothes.map((c) => c.toJson()).toList());

  /// Local calculation of pending amount (for UI display before save).
  double get localPendingAmount => totalBill - advancePayment;

  /// Creates an OrderModel from Supabase JSON response with joins.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customers'] as Map<String, dynamic>?;
    final clothesJson = json['order_clothes'] as List<dynamic>? ?? [];

    final parsedClothes = clothesJson.map((c) {
      final noteStr = c['measurement_note'] as String? ?? '';
      String measurementType = 'nap';
      String? subType = c['sub_type'] as String?;
      String measurements = '';
      
      if (noteStr.trim().startsWith('{') && noteStr.trim().endsWith('}')) {
        try {
          final decoded = jsonDecode(noteStr);
          measurementType = decoded['measurementType'] as String? ?? 'nap';
          subType ??= decoded['subType'] as String?;
          measurements = decoded['measurements'] as String? ?? '';
        } catch (_) {}
      } else {
        measurements = noteStr;
      }

      return ClothItem(
        id: c['id']?.toString(),
        clothType: c['cloth_type'] as String? ?? 'अन्य',
        measurementType: measurementType,
        subType: subType,
        measurements: measurements,
        charge: _toDouble(c['charge']),
        quantity: c['quantity'] as int? ?? 1,
      );
    }).toList();

    return OrderModel(
      id: json['id'].toString(),
      customerId: json['customer_id']?.toString() ?? '',
      customerName: customer?['customer_name'] as String? ?? 'अज्ञात',
      phoneNumber: customer?['phone_number'] as String?,
      advancePayment: _toDouble(json['advance_amount']),
      totalBill: _toDouble(json['total_amount']),
      pendingAmount: _toDoubleOrNull(json['remaining_amount']),
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'] as String)
          : null,
      clothes: parsedClothes,
    );
  }

  /// Creates a copy with updated fields.
  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? phoneNumber,
    double? advancePayment,
    double? totalBill,
    double? pendingAmount,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveryDate,
    List<ClothItem>? clothes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      advancePayment: advancePayment ?? this.advancePayment,
      totalBill: totalBill ?? this.totalBill,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      clothes: clothes ?? this.clothes,
    );
  }

  // ── Helpers ──

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
