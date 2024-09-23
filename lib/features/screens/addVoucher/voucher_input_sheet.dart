import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_number/features/models/voucher.dart';
import 'package:ticket_number/features/providers/voucher_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import 'package:ticket_number/core/constants/app_enums.dart';
import '../../widgets/vouchers/input_stepper.dart';

class VoucherInputSheet extends ConsumerStatefulWidget {
  final VoucherType voucherType;

  VoucherInputSheet({required this.voucherType});

  @override
  _VoucherInputSheetState createState() => _VoucherInputSheetState();
}

class _VoucherInputSheetState extends ConsumerState<VoucherInputSheet> {
// mendatory fields for all voucher types
  final _voucherNumberController = TextEditingController();
  final _licensePlateController = TextEditingController();

  // fields for voucher type 'tunnelMontBlanc'
  // mendatory fields 1. direction 2. date of transit
  Direction? direction;

  // optional fields
  final _driverNameController = TextEditingController();
  final _companyNameController = TextEditingController();

  // fields for voucher type 'tunnelFrejus'
  final _vehicleTypeController = TextEditingController();
  // optional
  final _euroClassController = TextEditingController();
  final _vehicleClassController = TextEditingController();
  // expiry date controller

  DateTime? _dateOfTransit = DateTime.now();
  DateTime? _expiryDate;

  int _currentStep = 0;
  late int _totalSteps;

  bool? isVoucherNumberValid;

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    if (widget.voucherType == VoucherType.tunnelMontBlanc) {
      _totalSteps = 4; // 4 mandatory steps
    } else if (widget.voucherType == VoucherType.tunnelFrejus) {
      _totalSteps = 3; // 3 mandatory steps
    }
  }

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0) {
        if (_voucherNumberController.text.length >= 10 ||
            _voucherNumberController.text.length <= 15) {
          setState(() {
            isVoucherNumberValid = true;
          });
        } else {
          setState(() {
            isVoucherNumberValid = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Voucher is not valid')));
        }
      } else {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      _saveVoucher();
      // _showOptionalFieldsOption();
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

  void _showOptionalFieldsOption() {
    // View for asking whether to add optional fields or save with default values
    // setState(() {
    //   _totalSteps++; // Add optional field step
    // });
  }

  void _saveVoucher() async {
    Voucher newVoucher = Voucher(
        voucherNumber: _voucherNumberController.text,
        type: widget.voucherType,
        dateOfTransit: _dateOfTransit!,
        licensePlateNumber: _licensePlateController.text,
        vehicleType: VehicleType.bus,
        direction: direction!);
    // Logic to save the voucher with the input values or defaults
    if (widget.voucherType == VoucherType.tunnelMontBlanc) {
      // Use default values for optional fields if not provided
      String driverName = _driverNameController.text.isEmpty
          ? 'Unknown Driver'
          : _driverNameController.text;
      String companyName = _companyNameController.text.isEmpty
          ? 'UNION TANK'
          : _companyNameController.text;

      // Save voucher logic
    } else if (widget.voucherType == VoucherType.tunnelFrejus) {
      // Set default expiry date and vehicle class based on vehicle type
      _expiryDate = _expiryDate ?? DateTime.now().add(Duration(days: 365));
      String vehicleClass;
      if (_vehicleTypeController.text == 'Bus') {
        vehicleClass = _vehicleClassController.text.isEmpty
            ? 'class4'
            : _vehicleClassController.text;
      } else {
        vehicleClass = _vehicleClassController.text.isEmpty
            ? 'all'
            : _vehicleClassController.text;
      }

      // Save voucher logic
    }

    await ref.read(voucherProvider.notifier).addVoucher(newVoucher);

    NavigationService().navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.85,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 2.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: _buildInputFields(),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    _buildNavigationButtons(),
                  ],
                ),
              )
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
    if (_currentStep < _totalSteps - 1) {
      switch (_currentStep) {
        case 0:
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter Voucher Number",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    isVoucherNumberValid = true;
                  });
                },
                controller: _voucherNumberController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: AppStrings.enterVoucherNumber,
                  // labelText: AppStrings.enterVoucherNumber,
                  fillColor: Color(0xffF2F3F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  // Set the same border for focused and enabled states
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Use transparent or your preferred color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Use transparent or your preferred color
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              isVoucherNumberValid ?? true
                  ? Container()
                  : Text(
                      "Voucher number should be between 10 to 15 characters",
                      style: TextStyle(color: Colors.red),
                    ),
            ],
          );

        case 1:
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter Vehicle Number",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _licensePlateController,
                decoration: InputDecoration(
                  // labelText: AppStrings.enterLicensePlateNumber,

                  filled: true,
                  hintText: AppStrings.enterLicensePlateNumber,
                  // labelText: AppStrings.enterVoucherNumber,
                  fillColor: Color(0xffF2F3F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  // Set the same border for focused and enabled states
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Use transparent or your preferred color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Use transparent or your preferred color
                  ),
                ),
              ),
            ],
          );
        case 2:
          if (widget.voucherType == VoucherType.tunnelMontBlanc) {
            return DropdownButtonFormField<Direction>(
              decoration: InputDecoration(
                labelText: AppStrings.direction,
                border: OutlineInputBorder(),
              ),
              items: Direction.values.map((Direction direction) {
                return DropdownMenuItem<Direction>(
                  value: direction,
                  child: Text(direction.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Update direction
                  direction = value;
                });
              },
            );
          } else if (widget.voucherType == VoucherType.tunnelFrejus) {
            return DropdownButtonFormField<VehicleType>(
              decoration: InputDecoration(
                labelText: AppStrings.vehicleType,
                border: OutlineInputBorder(),
              ),
              items: VehicleType.values.map((VehicleType type) {
                return DropdownMenuItem<VehicleType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Update vehicle type
                });
              },
            );
          }
          break;
        case 3:
          if (widget.voucherType == VoucherType.tunnelMontBlanc) {
            return TextField(
              decoration: InputDecoration(
                labelText: AppStrings.dateOfTransit,
                border: OutlineInputBorder(),
              ),
              onTap: () {
                // Show date picker and update dateOfTransit
              },
            );
          }
          break;
      }
    } else {
      // Optional fields step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.optionalFieldsPrompt,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 16.0),
          widget.voucherType == VoucherType.tunnelMontBlanc
              ? Column(
                  children: [
                    TextField(
                      controller: _driverNameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.enterDriverName,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.enterCompanyName,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    DropdownButtonFormField<EuroClass>(
                      decoration: InputDecoration(
                        labelText: AppStrings.selectEuroClassError,
                        border: OutlineInputBorder(),
                      ),
                      items: EuroClass.values.map((EuroClass euroClass) {
                        return DropdownMenuItem<EuroClass>(
                          value: euroClass,
                          child: Text(euroClass.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Update euro class
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppStrings.expirationDate,
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        // Show date picker and update expiry date
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<VehicleClass>(
                      decoration: InputDecoration(
                        labelText: AppStrings.enterVehicleClass,
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _getVehicleClassOptions(), // Dynamic based on vehicleType
                      onChanged: (value) {
                        // Update vehicle class
                      },
                    ),
                  ],
                ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  List<DropdownMenuItem<VehicleClass>> _getVehicleClassOptions() {
    // Return appropriate vehicle class options based on vehicleType
    if (_vehicleTypeController.text == 'Bus') {
      return [VehicleClass.class3, VehicleClass.class4]
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList();
    } else {
      return [
        VehicleClass.all,
        VehicleClass.classA,
        VehicleClass.classB,
        VehicleClass.class3,
        VehicleClass.class4
      ]
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList();
    }
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: _currentStep == 0
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          TextButton(
            onPressed: _goToPreviousStep,
            child: Text(AppStrings.back),
          ),
        ElevatedButton(
          onPressed: _goToNextStep,
          child: Text(_currentStep == _totalSteps - 1
              ? AppStrings.saveVoucher
              : AppStrings.next),
        ),
      ],
    );
  }
}
