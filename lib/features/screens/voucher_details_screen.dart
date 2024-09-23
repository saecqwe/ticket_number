import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/voucher.dart';
import '../widgets/pdf_generator_tunnel_frejus.dart';
import '../widgets/pdf_generator_tunnel_montblanc.dart';
import 'voucher_pdf_viewer.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_enums.dart';

class VoucherDetailsScreen extends StatelessWidget {
  final Voucher voucher;

  const VoucherDetailsScreen({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.voucherDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Center(
              child: Text(
                AppStrings.voucherDetails, // Fetch string from AppStrings
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            */
            const SizedBox(height: 80),
            Center(
              child: Column(
                children: [
                  Text(
                    AppStrings.voucherBarcode,
                    style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.primaryTextColor),
                  ),
                  const SizedBox(height: 10),
                  BarcodeWidget(
                    barcode: Barcode.code128(), // Choose the barcode type here
                    data: voucher.voucherNumber, // The data to be encoded
                    width: 220,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            /*
            const SizedBox(height: 20),
            _buildInfoCard(context, 'Voucher Number', voucher.voucherNumber),
            _buildInfoCard(
                context, 'Type', voucher.type.toString().split('.').last),
            _buildInfoCard(
                context, 'Date of Transit', voucher.dateOfTransit.toString()),
            _buildInfoCard(context, 'Direction',
                voucher.direction.toString().split('.').last),
            _buildInfoCard(context, 'Vehicle Type',
                voucher.vehicleType.toString().split('.').last),
            _buildInfoCard(context, 'Euro Class',
                voucher.euroClass.toString().split('.').last),
            _buildInfoCard(
                context, 'Status', voucher.status.toString().split('.').last),
            */
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Determine which PDF generator to use based on the voucher type
                  var pdfGenerator;

                  switch (voucher.type) {
                    case VoucherType.tunnelMontBlanc:
                      pdfGenerator = PdfGeneratorMontBlanc(voucher);
                      break;
                    case VoucherType.tunnelFrejus:
                      pdfGenerator = PdfGeneratorTunnelFrejus(voucher);
                      break;
                    // Handle other voucher types if needed
                  }

                  if (pdfGenerator != null) {
                    final pdfFile = await pdfGenerator.generatePdf();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VoucherPdfViewer(pdfFile: pdfFile),
                      ),
                    );
                  } else {
                    // Handle case where no valid voucher type is found (optional)
                    print('Unsupported voucher type');
                  }
                },
                child: const Text('Preview Voucher'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              _getIconForLabel(label),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Voucher Number':
        return Icons.confirmation_number;
      case 'Type':
        return Icons.label;
      case 'Date of Transit':
        return Icons.calendar_today;
      case 'Direction':
        return Icons.directions;
      case 'Vehicle Type':
        return Icons.directions_car;
      case 'Euro Class':
        return Icons.eco;
      case 'Status':
        return Icons.info;
      default:
        return Icons.help;
    }
  }
}
