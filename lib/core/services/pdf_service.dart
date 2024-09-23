import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../constants/app_strings.dart';

class PdfService {
  // Example method to generate a basic PDF
  static Future<void> generatePdf(String fileName) async {
    final pdf = Document();

    pdf.addPage(Page(
      build: (context) => Center(child: Text(AppStrings.addVoucher)),
    ));

    // Print or save the PDF
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Example method to preview a PDF
  static Future<void> previewPdf(String filePath) async {
    await Printing.layoutPdf(
      onLayout: (_) => File(filePath).readAsBytesSync(),
    );
  }
}
