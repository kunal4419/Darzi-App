import 'dart:convert';

/// Represents a single cloth item in an order.
class ClothItem {
  final String? id;
  final String clothType;
  final String measurementType; // 'nap' or 'purane_kapade'
  final String measurements; // empty if measurementType is 'purane_kapade'
  final String? subType; // 'pico', 'pico_fall', 'astar', 'sada', or null/empty
  final double charge;
  final int quantity;

  const ClothItem({
    this.id,
    required this.clothType,
    required this.measurementType,
    this.measurements = '',
    this.subType,
    this.charge = 0.0,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'clothType': clothType,
        'measurementType': measurementType,
        'measurements': measurements,
        'subType': subType,
        'charge': charge,
        'quantity': quantity,
      };

  factory ClothItem.fromJson(Map<String, dynamic> json) => ClothItem(
        id: json['id']?.toString(),
        clothType: json['clothType'] as String? ?? 'अन्य',
        measurementType: json['measurementType'] as String? ?? 'purane_kapade',
        measurements: json['measurements'] as String? ?? '',
        subType: json['subType'] as String?,
        charge: _toDouble(json['charge']),
        quantity: json['quantity'] as int? ?? 1,
      );

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Parses a JSON string of cloth items from `measurements` field.
  /// If parsing fails or is not JSON, returns a single item with raw text as legacy fallback.
  static List<ClothItem> parseMeasurements(
    String? measurementsStr,
    String? legacyClothType,
  ) {
    if (measurementsStr == null || measurementsStr.trim().isEmpty) {
      return [];
    }
    final trimmed = measurementsStr.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final List<dynamic> decoded = jsonDecode(trimmed);
        return decoded
            .map((e) => ClothItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Fallback
      }
    }
    // Legacy fallback: single cloth item
    return [
      ClothItem(
        clothType: legacyClothType ?? 'अन्य',
        measurementType: 'nap',
        measurements: measurementsStr,
      ),
    ];
  }
}
