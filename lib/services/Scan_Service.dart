import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class ScanService {
  Future<ScanResult> scan(BuildContext context) async {
    // 初始化各个识别器
    final barcodeScanner = BarcodeScanner();
    final textRecognizer = TextRecognizer();
    final languageIdentifier = LanguageIdentifier();

    try {
      // 初始化摄像头
      final cameras = await availableCameras();
      final camera = cameras.first;
      final cameraController = CameraController(camera, ResolutionPreset.max);
      await cameraController.initialize();

      // 扫描二维码和识别文本
      final barcodeScanningResults = await barcodeScanner.scanFromImage(InputImage.fromFilePath(cameraController.takePicture()));
      Barcode barcode;
      String recognizedText;
      if (barcodeScanningResults.barcodes.isNotEmpty) {
        barcode = barcodeScanningResults.barcodes.first;
        if (barcode.format == BarcodeFormat.QR_CODE) {
          final recognizedTextResult = await textRecognizer.processImage(InputImage.fromFilePath(barcode.rawValue));
          recognizedText = "";
          for (TextBlock block in recognizedTextResult.blocks) {
            for (TextLine line in block.lines) {
              recognizedText += line.text + "\n";
            }
          }
        }
      } else {
        // 没有二维码，进行文本识别
        final recognizedTextResult = await textRecognizer.processImage(InputImage.fromFilePath(cameraController.takePicture()));
        recognizedText = "";
        for (TextBlock block in recognizedTextResult.blocks) {
          for (TextLine line in block.lines) {
            recognizedText += line.text + "\n";
          }
        }
      }

      // 识别语言
      String languageCode;
      if (recognizedText != null) {
        final recognizedLanguage = await languageIdentifier.processText(recognizedText);
        languageCode = recognizedLanguage.languageCode;
      }

      // 释放摄像头
      await cameraController.dispose();

      // 显示选择对话框
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: '请选择',
          content: Text('识别到二维码和文本，请选择要处理的内容'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'barcode'),
              child: Text('二维码'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'text'),
              child: Text('文本'),
            ),
          ],
        ),
      );

      // 返回识别结果
      if (result == 'barcode') {
        return ScanResult(barcode: barcode);
      } else if (result == 'text') {
        return ScanResult(recognizedText: recognizedText, languageCode: languageCode);
      } else {
        return null;
      }
    } catch (error) {
      // 处理识别错误
      print(error);
      return null;
    }
  }
}

class ScanResult {
  final Barcode barcode;
  final String recognizedText;
  final String languageCode;

  ScanResult({
    this.barcode,
    this.recognizedText,
    this.languageCode,
  });
}
