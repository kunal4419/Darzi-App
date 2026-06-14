import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../models/order_model.dart';
import '../models/cloth_item.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.color = Colors.black26,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class BillReceiptWidget extends StatelessWidget {
  final OrderModel order;

  const BillReceiptWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Format currency to e.g. "₹1,000"
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final dateFormat = DateFormat('d MMM yyyy');

    final double total = order.totalBill;
    final double advance = order.advancePayment;
    final double remaining = order.pendingAmount ?? order.localPendingAmount;
    final bool isFullyPaid = remaining <= 0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 380, // Fixed width for WhatsApp preview optimization
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        decoration: BoxDecoration(
          color: Colors.white, // Pure white background
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: const [
                  Text(
                    'राखी टेलर्स',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.8,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '+91 8999614585',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const DashedDivider(height: 1.5, color: Colors.black26),
            const SizedBox(height: 16),

            // Customer Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ग्राहक (Customer)',
                        style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        order.customerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'दिनांक (Date)',
                      style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dateFormat.format(order.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const DashedDivider(height: 1.5, color: Colors.black26),
            const SizedBox(height: 16),

            // Items List
            if (order.clothes.isNotEmpty)
              ...order.clothes.map((item) => _buildItemRow(item, currencyFormat))
            else if (order.clothType != null && order.clothType!.isNotEmpty)
              _buildLegacyItemRow(order.clothType!, order.totalBill, currencyFormat),

            const SizedBox(height: 12),
            const DashedDivider(height: 1.5, color: Colors.black26),
            const SizedBox(height: 16),

            // Payment Summary Block
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('कुल बिल:', currencyFormat.format(total), isBold: true),
                  if (!isFullyPaid) ...[
                    const SizedBox(height: 8),
                    _buildSummaryRow('जमा:', currencyFormat.format(advance)),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: Colors.black12),
                    const SizedBox(height: 8),
                    _buildSummaryRow('बाकी:', currencyFormat.format(remaining), isBold: true, isRed: true),
                  ],
                ],
              ),
            ),

            if (isFullyPaid) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    border: Border.all(color: const Color(0xFF81C784), width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'पूर्ण भुगतान (PAID)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(ClothItem item, NumberFormat format) {
    final String clothName = item.clothType;
    final String subTypeStr = (item.subType != null && item.subType!.isNotEmpty) ? ' (${_getReadableSubType(item.subType!)})' : '';
    final String qtyStr = item.quantity > 1 ? ' x ${item.quantity}' : '';
    final String displayName = '$clothName$subTypeStr$qtyStr';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              displayName,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            format.format(item.charge),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegacyItemRow(String clothTypes, double totalCharge, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              clothTypes,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            format.format(totalCharge),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isRed ? const Color(0xFFC62828) : Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isRed ? const Color(0xFFC62828) : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getReadableSubType(String code) {
    switch (code) {
      case 'astar': return 'अस्तर';
      case 'sada': return 'सादा';
      case 'pico': return 'पीको';
      case 'pico_fall': return 'पीको फॉल';
      default: return code;
    }
  }
}
