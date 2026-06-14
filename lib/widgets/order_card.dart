import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../core/constants/darzi_colors.dart';
import '../core/constants/hindi_strings.dart';

/// Card widget displaying a summary of a customer order.
///
/// Layout:
/// - Row 1: Customer name (bold) + Date (right)
/// - Row 2: Cloth type chip + Phone number (if provided)
/// - Row 3: Advance ₹XX | Total ₹YY | Pending ₹ZZ (red if > 0)
///
/// Tap anywhere to open order detail.
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pending = order.pendingAmount ?? order.localPendingAmount;
    final hasPending = pending > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: Name + Date ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: DarziColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(order.createdAt),
                    style: const TextStyle(
                      fontSize: 13,
                      color: DarziColors.textGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Row 2: Phone on left + Cloth chips on right ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (order.phoneNumber != null &&
                      order.phoneNumber!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 14,
                          color: DarziColors.textGray,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          order.phoneNumber!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: DarziColors.textGray,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  if (order.clothType != null &&
                      order.clothType!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: order.clothType!
                          .split(',')
                          .map((t) => t.trim())
                          .where((t) => t.isNotEmpty)
                          .map((type) => Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: _ClothChip(label: type),
                              ))
                          .toList(),
                    )
                  else
                    const SizedBox(),
                ],
              ),

              const SizedBox(height: 10),

              // ── Divider ──
              const Divider(height: 1, color: DarziColors.divider),
              const SizedBox(height: 10),

              // ── Row 3: Payment summary ──
              Row(
                children: [
                  _PaymentChip(
                    label: HindiStrings.total,
                    amount: order.totalBill,
                    color: DarziColors.textDark,
                    bgColor: DarziColors.background,
                  ),
                  const SizedBox(width: 8),
                  _PaymentChip(
                    label: HindiStrings.advance,
                    amount: order.advancePayment,
                    color: DarziColors.primary,
                    bgColor: const Color(0xFFE3F2FD),
                  ),
                  const SizedBox(width: 8),
                  _PaymentChip(
                    label: HindiStrings.pending,
                    amount: pending,
                    color: hasPending
                        ? DarziColors.warning
                        : DarziColors.success,
                    bgColor: hasPending
                        ? DarziColors.warningLight
                        : DarziColors.successLight,
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}

/// Small colored chip for cloth type label.
class _ClothChip extends StatelessWidget {
  final String label;
  const _ClothChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: DarziColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Small payment summary chip (Advance / Total / Pending).
class _PaymentChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final Color bgColor;
  final bool isBold;

  const _PaymentChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.bgColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: DarziColors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
