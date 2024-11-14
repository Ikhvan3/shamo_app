// lib/providers/scanner_provider.dart
import 'package:flutter/material.dart';

import '../models/scan_informasi.dart';

class ScannerProvider extends ChangeNotifier {
  ProductInfo? _scannedProduct;
  bool _isLoading = false;
  String? _error;

  ProductInfo? get scannedProduct => _scannedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> processQRCode(String qrData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Processing QR Code: $qrData'); // Debug log

      if (qrData.isEmpty) {
        throw Exception('QR Code kosong');
      }

      // Parsing QR code data
      final product = ProductInfo.fromQRString(qrData);
      if (product == null) {
        throw Exception('Gagal memproses data QR Code');
      }

      _scannedProduct = product;
    } catch (e) {
      print('Error in processQRCode: $e'); // Debug log
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
