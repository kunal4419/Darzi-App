import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../core/constants/hindi_strings.dart';
import '../../../../core/constants/darzi_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/order_model.dart';
import '../../../../models/cloth_item.dart';
import '../../../../utils/share_bill_helper.dart';
import 'add_order_screen.dart';

/// Bottom sheet showing full details of a single order.
///
/// Shows all saved fields in Hindi.
/// Provides Edit and Delete actions.
/// Delete shows a confirmation AlertDialog before proceeding.
class OrderDetailBottomSheet extends StatelessWidget {
  final OrderModel order;

  const OrderDetailBottomSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final pending = order.pendingAmount ?? order.localPendingAmount;
    final hasPending = pending > 0;
    final ctrl = Get.find<OrderController>();
    final isGeneratingBill = ValueNotifier<bool>(false);

    final clothItems = ClothItem.parseMeasurements(order.measurements, order.clothType);
    final isStructured = order.measurements != null &&
        order.measurements!.trim().startsWith('[') &&
        order.measurements!.trim().endsWith(']');

    return Container(
      decoration: const BoxDecoration(
        color: DarziColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DarziColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    HindiStrings.orderDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DarziColors.textDark,
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isGeneratingBill,
                  builder: (context, isLoading, child) {
                    return TextButton.icon(
                      icon: isLoading 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.share, size: 18),
                      label: Text(isLoading ? 'Generating...' : 'बिल भेजे'),
                      style: TextButton.styleFrom(
                        foregroundColor: DarziColors.primary,
                      ),
                      onPressed: isLoading ? null : () async {
                        isGeneratingBill.value = true;
                        try {
                          await ShareBillHelper.shareOrderBill(context, order);
                        } finally {
                          if (context.mounted) {
                            isGeneratingBill.value = false;
                          }
                        }
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: DarziColors.textGray),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).padding.bottom > 0
                    ? MediaQuery.of(context).padding.bottom + 16
                    : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Customer Info ──
                  _buildInfoCard(children: [
                    _DetailRow(
                      icon: Icons.person,
                      label: HindiStrings.customerName,
                      value: order.customerName,
                      valueStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DarziColors.textDark,
                      ),
                    ),
                    if (order.phoneNumber != null &&
                        order.phoneNumber!.isNotEmpty) ...[
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 17, color: DarziColors.textGray),
                          const SizedBox(width: 8),
                          const Text(
                            '${HindiStrings.phoneNumber}: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: DarziColors.textGray,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              order.phoneNumber!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: DarziColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final url = Uri.parse('tel:${order.phoneNumber}');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: DarziColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.call, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'कॉल करें',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (order.clothType != null &&
                        order.clothType!.isNotEmpty) ...[
                      const Divider(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.checkroom, size: 17, color: DarziColors.textGray),
                          const SizedBox(width: 8),
                          const Text(
                            '${HindiStrings.clothType}: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: DarziColors.textGray,
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: order.clothType!
                                  .split(',')
                                  .map((type) => type.trim())
                                  .where((type) => type.isNotEmpty)
                                  .map((type) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE3F2FD),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          type,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: DarziColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (order.deliveryDate != null) ...[
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 17, color: DarziColors.textGray),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${DateFormat('d MMMM yyyy').format(order.deliveryDate!)} तक चाहिए',
                              style: const TextStyle(
                                fontSize: 15,
                                color: DarziColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ]),

                  const SizedBox(height: 12),

                  // ── Measurements / Clothes details ──
                  if (isStructured && clothItems.isNotEmpty)
                    _buildInfoCard(children: [
                      const _SectionHeader(
                          icon: Icons.checkroom,
                          label: HindiStrings.clothDetails),
                      const SizedBox(height: 12),
                      ...clothItems.asMap().entries.map((entry) {
                        return _ClothItemDetailRow(
                          index: entry.key,
                          item: entry.value,
                        );
                      }),
                    ])
                  else if (order.measurements != null &&
                      order.measurements!.isNotEmpty)
                    _buildInfoCard(children: [
                      const _SectionHeader(
                          icon: Icons.straighten,
                          label: HindiStrings.measurements),
                      const SizedBox(height: 8),
                      Text(
                        order.measurements!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: DarziColors.textDark,
                        ),
                      ),
                    ]),

                  if (order.measurements != null &&
                      order.measurements!.isNotEmpty)
                    const SizedBox(height: 12),

                  // ── Notes ──
                  if (order.notes != null && order.notes!.isNotEmpty)
                    _buildInfoCard(children: [
                      _SectionHeader(
                          icon: Icons.notes, label: HindiStrings.notes),
                      const SizedBox(height: 8),
                      Text(
                        order.notes!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: DarziColors.textDark,
                        ),
                      ),
                    ]),

                  if (order.notes != null && order.notes!.isNotEmpty)
                    const SizedBox(height: 12),

                  // ── Payment Summary ──
                  _buildInfoCard(children: [
                    _SectionHeader(
                        icon: Icons.currency_rupee,
                        label: 'बिल'),
                    const SizedBox(height: 12),

                    _PaymentRow(
                      label: '${HindiStrings.total}:',
                      value: '₹${order.totalBill.toStringAsFixed(0)}',
                      color: DarziColors.textDark,
                    ),
                    const SizedBox(height: 8),
                    _PaymentRow(
                      label: '${HindiStrings.advance}:',
                      value: '₹${order.advancePayment.toStringAsFixed(0)}',
                      color: DarziColors.primary,
                    ),
                    const Divider(height: 20),
                    _PaymentRow(
                      label: '${HindiStrings.pending}:',
                      value: '₹${pending.toStringAsFixed(0)}',
                      color: hasPending ? DarziColors.warning : DarziColors.success,
                      isBold: true,
                      fontSize: 17,
                    ),

                    if (hasPending) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: DarziColors.warningLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.info_outline,
                                size: 16, color: DarziColors.warning),
                            SizedBox(width: 6),
                            Text(
                              'बाकी राशि लेना बाकी है',
                              style: TextStyle(
                                fontSize: 13,
                                color: DarziColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ]),

                  const SizedBox(height: 20),

                  // ── Action Buttons ──
                  Row(
                    children: [
                      // Edit (Icon only)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close bottom sheet
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddOrderScreen(editOrder: order),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, color: DarziColors.primary),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE3F2FD),
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // "पूरा हुआ" (Action button to mark as paid)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _markAsFullyPaid(context, ctrl),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'पूरा हुआ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DarziColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Delete (Icon only)
                      IconButton(
                        onPressed: () => _confirmDelete(context, ctrl, order.id),
                        icon: const Icon(Icons.delete_outline, color: DarziColors.error),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEBEE),
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsFullyPaid(BuildContext context, OrderController ctrl) async {
    final updated = order.copyWith(
      advancePayment: order.totalBill,
      status: 'delivered', // mark as delivered/completed
    );
    final success = await ctrl.updateOrder(updated);
    if (success && context.mounted) {
      Navigator.of(context).pop(); // Close bottom sheet
    }
  }

  /// Shows Hindi confirmation dialog before deleting.
  Future<void> _confirmDelete(
    BuildContext context,
    OrderController ctrl,
    String orderId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          HindiStrings.deleteConfirmTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          HindiStrings.deleteConfirmMessage,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(HindiStrings.cancelDelete),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: DarziColors.error,
            ),
            child: const Text(HindiStrings.confirmDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(); // Close bottom sheet
      await ctrl.deleteOrder(orderId);
    }
  }





  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DarziColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(color: DarziColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: DarziColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: DarziColors.primary,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: DarziColors.textGray),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: DarziColors.textGray,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 15,
                  color: DarziColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;
  final double fontSize;

  const _PaymentRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: DarziColors.textGray,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ClothItemDetailRow extends StatefulWidget {
  final int index;
  final ClothItem item;

  const _ClothItemDetailRow({
    required this.index,
    required this.item,
  });

  @override
  State<_ClothItemDetailRow> createState() => _ClothItemDetailRowState();
}

class _ClothItemDetailRowState extends State<_ClothItemDetailRow> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine subtype label
    String? subTypeLabel;
    if (widget.item.subType != null && widget.item.subType!.isNotEmpty) {
      if (widget.item.subType == 'astar') {
        subTypeLabel = 'अस्तर';
      } else if (widget.item.subType == 'sada') {
        subTypeLabel = 'सादा';
      } else if (widget.item.subType == 'pico') {
        subTypeLabel = 'पीको';
      } else if (widget.item.subType == 'pico_fall') {
        subTypeLabel = 'पीको फॉल';
      } else {
        subTypeLabel = widget.item.subType;
      }
    }

    // Try decoding measurements JSON
    Map<String, dynamic> measurementsMap = {};
    bool isJson = false;
    if (widget.item.measurements.isNotEmpty) {
      final trimmed = widget.item.measurements.trim();
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          measurementsMap = jsonDecode(trimmed);
          isJson = true;
        } catch (_) {}
      }
    }

    // Check if measurement type is structured
    final isStructured = widget.item.measurementType == 'nap';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.item.clothType} x ${widget.item.quantity} (₹${widget.item.charge.toStringAsFixed(0)})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: DarziColors.textDark,
                  ),
                ),
              ),
              if (subTypeLabel != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    subTypeLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: DarziColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (widget.item.clothType != 'साड़ी') ...[
                if (isStructured)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isExpanded ? const Color(0xFFC8E6C9) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF81C784)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'नाप देखें',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 16,
                            color: const Color(0xFF2E7D32),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFB74D)),
                    ),
                    child: const Text(
                      'पुराना नाप',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),

        // Collapsible Content
        if (_isExpanded && isStructured) ...[
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DarziColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DarziColors.divider),
            ),
            child: isJson
                ? (measurementsMap.entries.where((e) => e.value.toString().trim().isNotEmpty).isEmpty
                    ? const Text(
                        'कोई नाप दर्ज नहीं है',
                        style: TextStyle(
                          fontSize: 14,
                          color: DarziColors.textGray,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: measurementsMap.entries
                            .where((e) => e.value.toString().trim().isNotEmpty)
                            .map((e) => _buildMeasurementBadge(e.key, e.value.toString()))
                            .toList(),
                      ))
                : Text(
                    widget.item.measurements,
                    style: const TextStyle(
                      fontSize: 14,
                      color: DarziColors.textDark,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
        ],
        const Divider(height: 16),
      ],
    );
  }

  Widget _buildMeasurementBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: DarziColors.textDark),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: DarziColors.textGray,
                fontWeight: FontWeight.normal,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

