import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

Future<String?> scanQrFromImage(File imageFile) async {
  final inputImage = InputImage.fromFile(imageFile);
  final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
  final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
  await barcodeScanner.close();

  if (barcodes.isEmpty) return null;

  return barcodes.first.rawValue;
}
