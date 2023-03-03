import 'dart:async';

import 'package:flutter/services.dart';

/// Provides access to the barcode scanner.
/// This class is an interface between the native Android and iOS classes and a
/// Flutter project.
class BarcodeScanner {
  static const MethodChannel _channel =
      MethodChannel('flutter_barcode_scanner');

  /// Scan with the camera until a barcode is identified, then return.
  /// Shows a scan line with [lineColor] over a scan window. A flash icon is
  /// displayed if [isShowFlashIcon] is true. The text of the cancel button can
  /// be customized with the [cancelButtonText] string.
  static Future<String> scanBarcode(
      String lineColor, String cancelButtonText, bool isShowFlashIcon) async {
    if (cancelButtonText.isEmpty) {
      cancelButtonText = 'Cancel';
    }

    // Pass params to the plugin
    Map params = <String, dynamic>{
      'lineColor': lineColor,
      'cancelButtonText': cancelButtonText,
      'isShowFlashIcon': isShowFlashIcon,
      'isContinuousScan': false
    };

    /// Get barcode scan result
    final barcodeResult =
        await _channel.invokeMethod('scanBarcode', params) ?? '';
    return barcodeResult;
  }
}
