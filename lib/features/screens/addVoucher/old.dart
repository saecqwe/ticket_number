import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import 'package:ticket_number/core/constants/app_enums.dart';
import '../../widgets/vouchers/input_stepper.dart';

class VoucherInputSheet extends StatefulWidget {
  final VoucherType voucherType;

  VoucherInputSheet({required this.voucherType});

  @override
  _VoucherInputSheetState createState() => _VoucherInputSheetState();
}

class _VoucherInputSheetState extends State<VoucherInputSheet> {
  final _voucherNumberController = TextEditingController();
  final _licensePlateController = TextEditingController();

  int _currentStep = 0;
  final int _totalSteps = 5; // Total mandatory fields steps

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _askForOptionalFields();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context); // Close the sheet if it's the first step
    }
  }

  void _askForOptionalFields() {
    // Show a final dialog to ask for optional fields or save voucher
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.optionalFieldsPrompt),
        actions: [
          TextButton(
            onPressed: () {
              _saveVoucher();
            },
            child: Text(AppStrings.saveVoucher),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open optional fields sheet here
              // You can create another sheet for this
            },
            child: Text(AppStrings.addOptionalFields),
          ),
        ],
      ),
    );
  }

  void _saveVoucher() {
    // Save voucher and navigate back to the home screen
    NavigationService().navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.66,
      minChildSize: 0.66, // Fixed height to 2/3rd
      maxChildSize: 0.66, // Prevent expansion
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      /*SizedBox(height: 16.0),
            StepProgressIndicator(
              totalSteps: _totalSteps,
              currentStep: _currentStep,
            ), */
                      SizedBox(height: 16.0),
                      Text(
                        _getPromptText(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 16.0),
                      _buildInputFields(),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goToNextStep,
                    child: Text(AppStrings.next),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:
                _goToPreviousStep, // Change to go back to the previous step
          ),
          Expanded(
            child: StepProgressIndicator(
              totalSteps: _totalSteps,
              currentStep: _currentStep,
            ),
          ),
          SizedBox(width: 48), // To balance the row with the back button
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    switch (_currentStep) {
      case 0:
        return TextField(
          controller: _voucherNumberController,
          decoration: InputDecoration(
            labelText: AppStrings.enterVoucherNumber,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        );
      case 1:
        return TextField(
          controller: _licensePlateController,
          decoration: InputDecoration(
            labelText: AppStrings.enterLicensePlateNumber,
            border: OutlineInputBorder(),
          ),
        );
      default:
        return SizedBox.shrink(); // Placeholder for other steps
    }
  }

  String _getPromptText() {
    switch (_currentStep) {
      case 0:
        return AppStrings.enterVoucherNumber;
      case 1:
        return AppStrings.enterLicensePlateNumber;
      default:
        return AppStrings.completeVoucherProcess;
    }
  }
}
