import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../core/constants/hindi_strings.dart';
import '../../../../core/constants/darzi_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/order_model.dart';
import '../../../../models/cloth_item.dart';
import '../../../../widgets/voice_input_field.dart';
import '../../../../widgets/cloth_type_chips.dart';
import '../../../../widgets/hindi_calendar_dialog.dart';

/// Screen for adding a new order or editing an existing one.
///
/// - All text fields support voice input via VoiceInputField
/// - Cloth type selected via quick-tap chips
/// - Pending amount calculated live as user types
/// - Hindi validation messages
/// - Loading state on save
class AddOrderScreen extends StatefulWidget {
  /// If [editOrder] is provided, the form is pre-filled for editing.
  final OrderModel? editOrder;

  const AddOrderScreen({super.key, this.editOrder});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<OrderController>();

  // ── Text Controllers ──
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _advanceCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<ClothFormItem> _clothItems = [];
  double _pendingPreview = 0.0;
  DateTime? _deliveryDate;

  bool get _isEditing => widget.editOrder != null;

  void _calculateTotalBill() {
    double total = 0.0;
    for (final item in _clothItems) {
      final charge = double.tryParse(item.chargeCtrl.text) ?? 0.0;
      total += charge;
    }
    _totalCtrl.text = total > 0 ? total.toStringAsFixed(0) : '';
    _updatePending();
  }

  void _addClothItem([ClothFormItem? item]) {
    final newItem = item ?? ClothFormItem();
    newItem.chargeCtrl.addListener(_calculateTotalBill);
    _clothItems.add(newItem);
  }

  @override
  void initState() {
    super.initState();

    // Pre-fill form if editing
    if (_isEditing) {
      final o = widget.editOrder!;
      _nameCtrl.text = o.customerName;
      _phoneCtrl.text = o.phoneNumber ?? '';
      _notesCtrl.text = o.notes ?? '';
      _advanceCtrl.text =
          o.advancePayment > 0 ? o.advancePayment.toStringAsFixed(0) : '';
      _totalCtrl.text =
          o.totalBill > 0 ? o.totalBill.toStringAsFixed(0) : '';
      _deliveryDate = o.deliveryDate;

      if (o.clothes.isEmpty) {
        _addClothItem();
      } else {
        for (final item in o.clothes) {
          final formItem = ClothFormItem(
            id: item.id,
            clothType: item.clothType,
            measurementType: item.measurementType,
            subType: item.subType,
            quantity: item.quantity,
            measurementsCtrl: TextEditingController(text: item.measurements),
            chargeCtrl: TextEditingController(
              text: item.charge > 0 ? item.charge.toStringAsFixed(0) : '',
            ),
          );

          if (item.measurements.trim().startsWith('{') && item.measurements.trim().endsWith('}')) {
            try {
              final Map<String, dynamic> decoded = jsonDecode(item.measurements);
              decoded.forEach((key, val) {
                if (formItem.structuredCtrls.containsKey(key)) {
                  formItem.structuredCtrls[key]!.text = val.toString();
                }
              });
            } catch (_) {}
          }
          _addClothItem(formItem);
        }
      }
    } else {
      _addClothItem();
    }

    // Listen to amount fields for live pending calculation
    _advanceCtrl.addListener(_updatePending);
    _totalCtrl.addListener(_updatePending);
  }

  void _updatePending() {
    final advance = double.tryParse(_advanceCtrl.text) ?? 0.0;
    final total = double.tryParse(_totalCtrl.text) ?? 0.0;
    setState(() => _pendingPreview = total - advance);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    for (final item in _clothItems) {
      item.dispose();
    }
    _notesCtrl.dispose();
    _advanceCtrl.dispose();
    _totalCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Save / Update ──

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final List<ClothItem> clothes = _clothItems.map((e) {
      String measurementsStr = '';
      if (e.clothType == 'ब्लाउज' || e.clothType == 'ड्रेस') {
        if (e.measurementType == 'nap') {
          final keys = e.clothType == 'ब्लाउज'
              ? ['लम्बाई', 'छाती', 'कमर', 'शोल्डर', 'मुंडा', 'आगे का गला', 'पीछे का गला', 'बाँही']
              : ['लम्बाई', 'छाती', 'कमर', 'शोल्डर', 'मुंडा', 'आगे का गला', 'पीछे का गला', 'बाँही', 'पैंट लम्बाई', 'सीट', 'बॉटम'];
          final map = {
            for (final k in keys) k: e.structuredCtrls[k]!.text.trim()
          };
          measurementsStr = jsonEncode(map);
        }
      } else {
        measurementsStr = e.measurementType == 'nap' ? e.measurementsCtrl.text.trim() : '';
      }

      return ClothItem(
        id: e.id,
        clothType: e.clothType ?? 'अन्य',
        measurementType: e.measurementType,
        subType: e.subType,
        measurements: e.clothType == 'साड़ी' ? '' : measurementsStr,
        charge: double.tryParse(e.chargeCtrl.text) ?? 0.0,
        quantity: e.quantity,
      );
    }).toList();

    final order = OrderModel(
      id: _isEditing ? widget.editOrder!.id : '',
      customerId: _isEditing ? widget.editOrder!.customerId : null,
      customerName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim().isEmpty
          ? null
          : _phoneCtrl.text.trim(),
      clothes: clothes,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      advancePayment: double.tryParse(_advanceCtrl.text) ?? 0.0,
      totalBill: double.tryParse(_totalCtrl.text) ?? 0.0,
      status: _isEditing ? widget.editOrder!.status : 'pending',
      createdAt: _isEditing ? widget.editOrder!.createdAt : DateTime.now(),
      deliveryDate: _deliveryDate,
    );

    bool success;
    if (_isEditing) {
      success = await _controller.updateOrder(order);
    } else {
      success = await _controller.addOrder(order);
    }

    if (success && mounted) {
      if (_isEditing) {
        Navigator.of(context).pop(); // Return to detail sheet
      } else {
        _clearForm();
      }
    }
  }

  void _clearForm() {
    FocusScope.of(context).unfocus();
    _nameCtrl.clear();
    _phoneCtrl.clear();
    _notesCtrl.clear();
    _advanceCtrl.clear();
    _totalCtrl.clear();
    for (final item in _clothItems) {
      item.dispose();
    }
    setState(() {
      _clothItems.clear();
      _addClothItem();
      _pendingPreview = 0.0;
      _deliveryDate = null;
    });
    _formKey.currentState?.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarziColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing
              ? HindiStrings.editOrderTitle
              : HindiStrings.addOrderTitle,
        ),
        automaticallyImplyLeading: _isEditing,
      ),
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
                      children: [
                        // ── Customer Name (Required) ──
                        VoiceInputField(
                          controller: _nameCtrl,
                          label: HindiStrings.customerName,
                          hint: HindiStrings.customerNameHint,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return HindiStrings.nameRequired;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ── Phone Number ──
                        _buildSectionLabel(HindiStrings.phoneNumber),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: HindiStrings.phoneNumberHint,
                            prefixIcon: const Icon(Icons.phone_outlined,
                                color: DarziColors.textGray),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Clothes List ──
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _clothItems.length,
                          itemBuilder: (context, index) {
                            return _buildClothItemCard(index);
                          },
                        ),

                        const SizedBox(height: 12),

                        // ── Add Cloth Button ──
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _addClothItem();
                            });
                          },
                          icon: const Icon(Icons.add, color: DarziColors.primary),
                          label: const Text(
                            HindiStrings.addClothButton,
                            style: TextStyle(
                              color: DarziColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: DarziColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Additional Notes ──
                        VoiceInputField(
                          controller: _notesCtrl,
                          label: HindiStrings.notes,
                          hint: HindiStrings.notesHint,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 20),

                        // ── Delivery Date Selector ──
                        _buildDeliveryDatePicker(),

                        const SizedBox(height: 20),

                        // ── Payment Section ──
                        _buildPaymentSection(),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                _buildStickyBottomBar(),
              ],
            ),

            // ── Loading overlay ──
            if (_controller.isSaving.value)
              Container(
                color: Colors.black.withValues(alpha: 0.1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.horizontalPadding,
        12,
        AppConstants.horizontalPadding,
        MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 12
            : 16,
      ),
      decoration: BoxDecoration(
        color: DarziColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: const Border(
          top: BorderSide(color: DarziColors.divider),
        ),
      ),
      child: _isEditing
          ? ElevatedButton(
              onPressed: _controller.isSaving.value ? null : _onSave,
              child: _controller.isSaving.value
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      HindiStrings.updateButton,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: _clearForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: DarziColors.textGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                      ),
                    ),
                    child: const Text(
                      HindiStrings.clearButton,
                      style: TextStyle(
                        color: DarziColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _controller.isSaving.value ? null : _onSave,
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            HindiStrings.saveButton,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDeliveryDatePicker() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DarziColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(color: DarziColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'कब तक चाहिए',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: DarziColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => HindiCalendarDialog(
                  initialDate: _deliveryDate ?? DateTime.now().add(const Duration(days: 2)),
                  onDateSelected: (picked) {
                    setState(() {
                      _deliveryDate = picked;
                    });
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: DarziColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: DarziColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: DarziColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _deliveryDate == null
                          ? 'तारीख चुनें'
                          : DateFormat('dd MMMM yyyy').format(_deliveryDate!),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: _deliveryDate == null ? FontWeight.normal : FontWeight.bold,
                        color: _deliveryDate == null ? DarziColors.textGray : DarziColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: DarziColors.textGray),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DarziColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(color: DarziColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──
          const Text(
            'बिल',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DarziColors.textDark,
            ),
          ),

          const SizedBox(height: 14),

          // ── Advance + Total fields side by side ──
          Row(
            children: [
              Expanded(
                child: _buildAmountField(
                  label: HindiStrings.totalBill,
                  controller: _totalCtrl,
                  hint: HindiStrings.totalBillHint,
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAmountField(
                  label: HindiStrings.advancePayment,
                  controller: _advanceCtrl,
                  hint: HindiStrings.advancePaymentHint,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Pending amount preview ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _pendingPreview > 0
                  ? DarziColors.warningLight
                  : DarziColors.successLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _pendingPreview > 0
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: _pendingPreview > 0
                      ? DarziColors.warning
                      : DarziColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${HindiStrings.pendingAmount}: ₹${_pendingPreview.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _pendingPreview > 0
                        ? DarziColors.warning
                        : DarziColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: DarziColors.textGray,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: hint,
            prefixText: '₹ ',
            prefixStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: DarziColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: DarziColors.textDark,
      ),
    );
  }

  Widget _buildClothItemCard(int index) {
    final item = _clothItems[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DarziColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(color: DarziColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.borderRadiusMd - 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${HindiStrings.clothNumberLabel} #${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: DarziColors.textDark,
                  ),
                ),
                if (_clothItems.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: DarziColors.error, size: 20),
                    onPressed: () {
                      setState(() {
                        item.dispose();
                        _clothItems.removeAt(index);
                        _calculateTotalBill();
                      });
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(HindiStrings.clothType),
                const SizedBox(height: 8),
                ClothTypeChips(
                  selected: item.clothType,
                  onSelected: (type) =>
                      setState(() {
                        item.clothType = type;
                        if (type == 'साड़ी') {
                          if (item.subType != 'pico' && item.subType != 'pico_fall') {
                            item.subType = 'pico';
                          }
                        } else if (type == 'ब्लाउज' || type == 'ड्रेस') {
                          if (item.subType != 'astar' && item.subType != 'sada') {
                            item.subType = 'astar';
                          }
                        } else {
                          item.subType = null;
                        }
                      }),
                ),

                // Auto-hiding / step-by-step layout based on selected cloth type
                if (item.clothType != null) ...[
                  _buildSubtypeOptions(item),
                  _buildQuantitySelector(item),
                  _buildMeasurementTypeSelector(item),
                  _buildStructuredMeasurements(item),
                  _buildStitchingChargeField(item),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtypeOptions(ClothFormItem item) {
    if (item.clothType == 'ब्लाउज' || item.clothType == 'ड्रेस') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          _buildSectionLabel('प्रकार'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMeasurementTypeChip(
                label: 'अस्तर',
                isSelected: item.subType == 'astar',
                onTap: () {
                  setState(() {
                    item.subType = 'astar';
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildMeasurementTypeChip(
                label: 'सादा',
                isSelected: item.subType == 'sada',
                onTap: () {
                  setState(() {
                    item.subType = 'sada';
                  });
                },
              ),
            ],
          ),
        ],
      );
    } else if (item.clothType == 'साड़ी') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          _buildSectionLabel('प्रकार'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMeasurementTypeChip(
                label: 'पीको',
                isSelected: item.subType == 'pico',
                onTap: () {
                  setState(() {
                    item.subType = 'pico';
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildMeasurementTypeChip(
                label: 'पीको फॉल',
                isSelected: item.subType == 'pico_fall',
                onTap: () {
                  setState(() {
                    item.subType = 'pico_fall';
                  });
                },
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildQuantitySelector(ClothFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        const Text(
          'मात्रा',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: DarziColors.textGray,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: 150,
          decoration: BoxDecoration(
            color: DarziColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DarziColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18, color: DarziColors.textDark),
                onPressed: () {
                  if (item.quantity > 1) {
                    setState(() {
                      item.quantity--;
                      _calculateTotalBill();
                    });
                  }
                },
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: DarziColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18, color: DarziColors.primary),
                onPressed: () {
                  setState(() {
                    item.quantity++;
                    _calculateTotalBill();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementTypeSelector(ClothFormItem item) {
    if (item.clothType == 'साड़ी') {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        _buildSectionLabel('नाप का प्रकार'),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildMeasurementTypeChip(
              label: HindiStrings.napOption,
              isSelected: item.measurementType == 'nap',
              onTap: () {
                setState(() {
                  item.measurementType = 'nap';
                });
              },
            ),
            const SizedBox(width: 12),
            _buildMeasurementTypeChip(
              label: HindiStrings.puraneKapadeOption,
              isSelected: item.measurementType == 'purane_kapade',
              onTap: () {
                setState(() {
                  item.measurementType = 'purane_kapade';
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStructuredMeasurements(ClothFormItem item) {
    if (item.clothType == 'साड़ी' || item.measurementType != 'nap') {
      return const SizedBox.shrink();
    }

    if (item.clothType == 'ब्लाउज') {
      return Container(
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DarziColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DarziColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'नाप लिखे',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: DarziColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldRow('लम्बाई', item.structuredCtrls['लम्बाई']!, 'छाती', item.structuredCtrls['छाती']!),
            _buildFieldRow('कमर', item.structuredCtrls['कमर']!, 'शोल्डर', item.structuredCtrls['शोल्डर']!),
            _buildFieldRow('मुंडा', item.structuredCtrls['मुंडा']!, 'आगे का गला', item.structuredCtrls['आगे का गला']!),
            _buildFieldRow('पीछे का गला', item.structuredCtrls['पीछे का गला']!, 'बाँही', item.structuredCtrls['बाँही']!),
          ],
        ),
      );
    } else if (item.clothType == 'ड्रेस') {
      return Container(
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DarziColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DarziColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'नाप लिखे',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: DarziColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldRow('लम्बाई', item.structuredCtrls['लम्बाई']!, 'छाती', item.structuredCtrls['छाती']!),
            _buildFieldRow('कमर', item.structuredCtrls['कमर']!, 'शोल्डर', item.structuredCtrls['शोल्डर']!),
            _buildFieldRow('मुंडा', item.structuredCtrls['मुंडा']!, 'आगे का गला', item.structuredCtrls['आगे का गला']!),
            _buildFieldRow('पीछे का गला', item.structuredCtrls['पीछे का गला']!, 'बाँही', item.structuredCtrls['बाँही']!),
            const Divider(height: 24, color: DarziColors.divider),
            const Text(
              'पैंट का नाप',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: DarziColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldRow('पैंट लम्बाई', item.structuredCtrls['पैंट लम्बाई']!, 'सीट', item.structuredCtrls['सीट']!),
            _buildSingleFieldRow('बॉटम', item.structuredCtrls['बॉटम']!),
          ],
        ),
      );
    } else if (item.clothType == 'फ्रॉक') {
      return Container(
        margin: const EdgeInsets.only(top: 14),
        child: VoiceInputField(
          controller: item.measurementsCtrl,
          label: HindiStrings.measurements,
          hint: HindiStrings.measurementsHint,
          maxLines: 3,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildStitchingChargeField(ClothFormItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        _buildSectionLabel('सिलाई शुल्क (₹)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: item.chargeCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            hintText: 'सिलाई शुल्क दर्ज करें (उदा. 300)',
            prefixText: '₹ ',
            prefixStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: DarziColors.textDark,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'शुल्क दर्ज करना जरूरी है';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMeasurementField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DarziColors.textGray,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: '0',
          ),
        ),
      ],
    );
  }

  Widget _buildFieldRow(String label1, TextEditingController ctrl1, String label2, TextEditingController ctrl2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _buildMeasurementField(label1, ctrl1)),
          const SizedBox(width: 12),
          Expanded(child: _buildMeasurementField(label2, ctrl2)),
        ],
      ),
    );
  }

  Widget _buildSingleFieldRow(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _buildMeasurementField(label, ctrl)),
          const SizedBox(width: 12),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildMeasurementTypeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? DarziColors.primary : DarziColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? DarziColors.primary : DarziColors.divider,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: DarziColors.primary.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : DarziColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper class to track a cloth item in the AddOrder screen form.
class ClothFormItem {
  String? id;
  String? clothType;
  String measurementType; // 'nap' or 'purane_kapade'
  String? subType; // 'pico', 'pico_fall', 'astar', 'sada', or null
  int quantity;
  final TextEditingController measurementsCtrl;
  final TextEditingController chargeCtrl;
  final Map<String, TextEditingController> structuredCtrls;

  ClothFormItem({
    this.id,
    this.clothType,
    this.measurementType = 'purane_kapade',
    this.subType,
    this.quantity = 1,
    TextEditingController? measurementsCtrl,
    TextEditingController? chargeCtrl,
    Map<String, TextEditingController>? structuredCtrls,
  })  : measurementsCtrl = measurementsCtrl ?? TextEditingController(),
        chargeCtrl = chargeCtrl ?? TextEditingController(),
        structuredCtrls = structuredCtrls ?? {
          'लम्बाई': TextEditingController(),
          'छाती': TextEditingController(),
          'कमर': TextEditingController(),
          'शोल्डर': TextEditingController(),
          'मुंडा': TextEditingController(),
          'आगे का गला': TextEditingController(),
          'पीछे का गला': TextEditingController(),
          'बाँही': TextEditingController(),
          'पैंट लम्बाई': TextEditingController(),
          'सीट': TextEditingController(),
          'बॉटम': TextEditingController(),
        };

  void dispose() {
    measurementsCtrl.dispose();
    chargeCtrl.dispose();
    for (final ctrl in structuredCtrls.values) {
      ctrl.dispose();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clothType': clothType ?? 'अन्य',
        'measurementType': measurementType,
        'measurements': clothType == 'साड़ी' ? '' : (measurementType == 'nap' ? measurementsCtrl.text.trim() : ''),
        'subType': subType,
        'charge': double.tryParse(chargeCtrl.text) ?? 0.0,
        'quantity': quantity,
      };
}
