import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/voucher.dart';
import 'package:flutter/services.dart' show rootBundle;

/* Dummz Data used */
class PdfGeneratorTunnelFrejus {
  final Voucher voucher;

  PdfGeneratorTunnelFrejus(this.voucher);

  Future<File> generatePdf() async {
    final pdf = pw.Document();

    // Load the images for the logos
    final logoLeft = pw.MemoryImage(
      (await rootBundle.load('assets/images/sftrf_logo.png'))
          .buffer
          .asUint8List(),
    );

    final logoRight = pw.MemoryImage(
      (await rootBundle.load('assets/images/sitaf_logo.png'))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header section with logos and title
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoLeft, width: 100),
                    pw.Column(
                      children: [
                        pw.Text(
                          'BON DE PASSAGE',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'BUONO DI TRANSITO',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Image(logoRight, width: 100),
                  ],
                ),
                pw.SizedBox(height: 20),
                // "Buono Virtuale" Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'BUONO VIRTUALE',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '00000-1088',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                // Voucher Details
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Categoria : VP'),
                          pw.Text('Classe : Tutte le classi'),
                          pw.Text('Classe euro : Tutte'),
                          pw.Text('Autoriz. MP'),
                          pw.Text('Targa : ${voucher.licensePlateNumber}'),
                          pw.Text('Rif: 1888165'),
                          pw.SizedBox(height: 20),
                          pw.Text(
                            'Data Scadenza: 30/04/2025 23:59:59',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.BarcodeWidget(
                            data: '530704720746',
                            barcode: pw.Barcode.code128(),
                            width: 200,
                            height: 120, // Further increased barcode height
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                // Footer section with wider box and centered text
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    width: 400, // Increased width of footer box
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(width: 1),
                    ),
                    child: pw.Text(
                      'CORSA SEMPLICE VP Tutte le classi',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'All\'interno del Frejus: velocità: min 50, max 70Km; distanza min tra i veicoli: 150m\n'
                  'SITAF SpA: T4-Traforo del Frejus +39 0122909011 www.sitaf.it',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.normal,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/voucher_${voucher.voucherNumber}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
