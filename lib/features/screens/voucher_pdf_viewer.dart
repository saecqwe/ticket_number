import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class VoucherPdfViewer extends StatelessWidget {
  final File pdfFile;

  VoucherPdfViewer({required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voucher Preview')),
      body: PDFView(
        filePath: pdfFile.path,
      ),
    );
  }
}
