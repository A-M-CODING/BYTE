import 'dart:io';
import 'package:pdf_text/pdf_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PDFUtilities {
  static Future<String> extractTextFromPdf(File file) async {
    try {
      print("Trying to create PDFDoc from file: ${file.path}");
      PDFDoc doc = await PDFDoc.fromFile(file);
      String extractedText = await doc.text;

      // Log the extracted text or indicate that no text was extracted
      if (extractedText.isEmpty) {
        print("No text was extracted from the PDF.");
      } else {
        print("Extracted text: ${extractedText.substring(0, 100)}..."); // Print the first 100 characters to avoid log overflow
      }

      return extractedText;
    } catch (e, stacktrace) {
      print("Error extracting text from PDF: $e");
      print("Stacktrace: $stacktrace");
      return 'Error: Could not extract text.';
    }
  }

  // Method to process multiple PDF files and extract text from each
  Future<Map<String, String>> processPdfFiles(List<PlatformFile> files) async {
    Map<String, String> extractedTexts = {};
    for (var file in files) {
      String filePath = file.path!;
      print("Processing file: $filePath"); // Debug: Log file path

      File pdfFile = File(filePath);
      PDFDoc doc = await PDFDoc.fromFile(pdfFile);
      String text = await doc.text;
      extractedTexts[filePath] = text;

      print("Extracted text from $filePath: ${text.substring(0, 100)}..."); // Debug: Log extracted text
    }
    return extractedTexts;
  }

  // Method to check storage permissions, especially for mobile platforms
  static Future<bool> _checkPermission() async {
    if (!kIsWeb) { // Only perform permission checks on non-web platforms
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        return result.isGranted;
      }
    }
    return true; // Assume permission is granted on web
  }
}
