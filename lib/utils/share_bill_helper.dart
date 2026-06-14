import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/order_model.dart';
import '../widgets/bill_receipt_widget.dart';

class ShareBillHelper {
  static Future<void> shareOrderBill(BuildContext context, OrderModel order) async {
    try {
      final screenshotController = ScreenshotController();

      // Render the widget to an image
      final bytes = await screenshotController.captureFromWidget(
        BillReceiptWidget(order: order),
        context: context,
        delay: const Duration(milliseconds: 100),
      );

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/receipt_${order.id}.png';

      // Save the image
      final file = File(imagePath);
      await file.writeAsBytes(bytes);

      // Share the file
      final xFile = XFile(imagePath, mimeType: 'image/png');
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
        ),
      );
    } catch (e) {
      debugPrint('Error sharing bill: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('बिल शेयर करने में त्रुटि हुई।')),
        );
      }
    }
  }
}
