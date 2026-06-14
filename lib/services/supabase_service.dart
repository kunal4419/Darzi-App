import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Global supabase client
import '../models/order_model.dart';

/// Service layer for all Supabase database operations.
///
/// Handles all customer details, orders, and clothes queries across 3 tables.
class SupabaseService {
  // ── Singleton ──
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // ────────────────────────────────────────────────────────────
  // CREATE — Insert a new order
  // ────────────────────────────────────────────────────────────

  /// Inserts a new order into Supabase using transactions/sequenced inserts.
  Future<OrderModel> insertOrder(OrderModel order) async {
    try {
      // 1. Find or create customer
      String customerId;
      if (order.phoneNumber != null && order.phoneNumber!.isNotEmpty) {
        final existing = await supabase
            .from('customers')
            .select('id')
            .eq('phone_number', order.phoneNumber!)
            .maybeSingle();

        if (existing != null) {
          customerId = existing['id'].toString();
        } else {
          final newCust = await supabase
              .from('customers')
              .insert({
                'customer_name': order.customerName,
                'phone_number': order.phoneNumber,
              })
              .select('id')
              .single();
          customerId = newCust['id'].toString();
        }
      } else {
        final newCust = await supabase
            .from('customers')
            .insert({
              'customer_name': order.customerName,
            })
            .select('id')
            .single();
        customerId = newCust['id'].toString();
      }

      // 2. Insert order
      final newOrder = await supabase
          .from('orders')
          .insert({
            'customer_id': customerId,
            'total_amount': order.totalBill,
            'advance_amount': order.advancePayment,
            'remaining_amount': order.totalBill - order.advancePayment,
            'status': order.status,
            'delivery_date': order.deliveryDate?.toIso8601String(),
          })
          .select('id, created_at')
          .single();
      final orderId = newOrder['id'].toString();

      // 3. Insert order clothes
      if (order.clothes.isNotEmpty) {
        final clothesToInsert = order.clothes.map((item) {
          final noteJson = jsonEncode({
            'measurementType': item.measurementType,
            'subType': item.subType,
            'measurements': item.measurements,
          });
          return {
            'order_id': orderId,
            'cloth_type': item.clothType,
            'sub_type': item.subType,
            'measurement_note': noteJson,
            'charge': item.charge,
            'quantity': item.quantity,
          };
        }).toList();

        await supabase.from('order_clothes').insert(clothesToInsert);
      }

      // 4. Retrieve complete nested order for return
      return getOrderById(orderId);
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e);
    } catch (e) {
      throw 'ऑर्डर सहेजने में गड़बड़ी, दोबारा कोशिश करें।';
    }
  }

  // ────────────────────────────────────────────────────────────
  // READ — Fetch all orders
  // ────────────────────────────────────────────────────────────

  /// Returns all orders sorted by newest first with nested customer and clothes tables joined.
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await supabase.from('orders').select('''
        *,
        customers (
          customer_name,
          phone_number
        ),
        order_clothes (
          id,
          cloth_type,
          sub_type,
          measurement_note,
          charge,
          quantity
        )
      ''').order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e);
    } catch (e) {
      throw 'ऑर्डर लोड नहीं हो सके, दोबारा कोशिश करें।';
    }
  }

  /// Helper to fetch a single order by ID with all joins.
  Future<OrderModel> getOrderById(String orderId) async {
    final response = await supabase
        .from('orders')
        .select('''
          *,
          customers (
            customer_name,
            phone_number
          ),
          order_clothes (
            id,
            cloth_type,
            sub_type,
            measurement_note,
            charge,
            quantity
          )
        ''')
        .eq('id', orderId)
        .single();
    return OrderModel.fromJson(response);
  }

  // ────────────────────────────────────────────────────────────
  // SEARCH — Search orders by name or phone
  // ────────────────────────────────────────────────────────────

  /// Searches orders by customer name (case-insensitive) OR phone number.
  Future<List<OrderModel>> searchOrders(String query) async {
    if (query.trim().isEmpty) return getAllOrders();

    try {
      final cleanQuery = query.trim();
      final isPhone = RegExp(r'^\d+$').hasMatch(cleanQuery);

      List<dynamic> response;

      if (isPhone) {
        response = await supabase
            .from('orders')
            .select('''
              *,
              customers!inner (
                customer_name,
                phone_number
              ),
              order_clothes (
                id,
                cloth_type,
                sub_type,
                measurement_note,
                charge,
                quantity
              )
            ''')
            .ilike('customers.phone_number', '%$cleanQuery%')
            .order('created_at', ascending: false);
      } else {
        response = await supabase
            .from('orders')
            .select('''
              *,
              customers!inner (
                customer_name,
                phone_number
              ),
              order_clothes (
                id,
                cloth_type,
                sub_type,
                measurement_note,
                charge,
                quantity
              )
            ''')
            .ilike('customers.customer_name', '%$cleanQuery%')
            .order('created_at', ascending: false);
      }

      return (response)
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e);
    } catch (e) {
      throw 'खोज में गड़बड़ी, दोबारा कोशिश करें।';
    }
  }

  // ────────────────────────────────────────────────────────────
  // UPDATE — Edit an existing order
  // ────────────────────────────────────────────────────────────

  /// Updates an existing order. Returns the updated record.
  Future<OrderModel> updateOrder(OrderModel order) async {
    try {
      // 1. Update customer info if customerId is present
      if (order.customerId != null && order.customerId!.isNotEmpty) {
        await supabase
            .from('customers')
            .update({
              'customer_name': order.customerName,
              'phone_number': order.phoneNumber,
            })
            .eq('id', order.customerId!);
      }

      // 2. Update order values
      await supabase
          .from('orders')
          .update({
            'total_amount': order.totalBill,
            'advance_amount': order.advancePayment,
            'remaining_amount': order.totalBill - order.advancePayment,
            'status': order.status,
            'delivery_date': order.deliveryDate?.toIso8601String(),
          })
          .eq('id', order.id);

      // 3. Re-sync order clothes: delete old ones and insert updated ones
      await supabase
          .from('order_clothes')
          .delete()
          .eq('order_id', order.id);

      if (order.clothes.isNotEmpty) {
        final clothesToInsert = order.clothes.map((item) {
          final noteJson = jsonEncode({
            'measurementType': item.measurementType,
            'subType': item.subType,
            'measurements': item.measurements,
          });
          return {
            'order_id': order.id,
            'cloth_type': item.clothType,
            'sub_type': item.subType,
            'measurement_note': noteJson,
            'charge': item.charge,
            'quantity': item.quantity,
          };
        }).toList();

        await supabase.from('order_clothes').insert(clothesToInsert);
      }

      return getOrderById(order.id);
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e);
    } catch (e) {
      throw 'ऑर्डर अपडेट करने में गड़बड़ी, दोबारा कोशिश करें।';
    }
  }

  // ────────────────────────────────────────────────────────────
  // DELETE — Remove an order
  // ────────────────────────────────────────────────────────────

  /// Permanently deletes an order.
  Future<void> deleteOrder(String id) async {
    try {
      await supabase.from('orders').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e);
    } catch (e) {
      throw 'ऑर्डर हटाने में गड़बड़ी, दोबारा कोशिश करें।';
    }
  }

  // ────────────────────────────────────────────────────────────
  // Error handling
  // ────────────────────────────────────────────────────────────

  String _handlePostgrestError(PostgrestException e) {
    if (e.code == '23502') {
      return 'ग्राहक का नाम जरूरी है।';
    }
    if (e.message.toLowerCase().contains('network') ||
        e.message.toLowerCase().contains('connection')) {
      return 'इंटरनेट नहीं है, दोबारा कोशिश करें।';
    }
    return 'डेटाबेस में गड़बड़ी: ${e.message}';
  }
}
