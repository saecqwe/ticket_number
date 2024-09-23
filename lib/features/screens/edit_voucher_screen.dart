import 'package:flutter/material.dart';
import '../models/voucher.dart';
import '../providers/voucher_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import 'package:ticket_number/core/constants/app_enums.dart';


class EditVoucherScreen extends ConsumerStatefulWidget {
  final Voucher? voucher;

  EditVoucherScreen({this.voucher});

  @override
  ConsumerState<EditVoucherScreen> createState() => _EditVoucherScreenState();
}

class _EditVoucherScreenState extends ConsumerState<EditVoucherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _voucherNumberController = TextEditingController();
  final _tmbCardNumberController = TextEditingController();
  final _licensePlateNumberController = TextEditingController();
  DateTime? _dateOfTransit;
  VoucherType? _type;
  Direction? _direction;
  VehicleType? _vehicleType;
  EuroClass? _euroClass;
  Status? _status;

  @override
  void initState() {
    super.initState();
    if (widget.voucher != null) {
      _voucherNumberController.text = widget.voucher!.voucherNumber;
      _tmbCardNumberController.text = widget.voucher!.tmbCardNumber;
      _licensePlateNumberController.text = widget.voucher!.licensePlateNumber;
      _dateOfTransit = widget.voucher!.dateOfTransit;
      _type = widget.voucher!.type;
      _direction = widget.voucher!.direction;
      _vehicleType = widget.voucher!.vehicleType;
      _euroClass = widget.voucher!.euroClass;
      _status = widget.voucher!.status;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newVoucher = Voucher(
        voucherNumber: _voucherNumberController.text,
        type: _type!,
        dateOfTransit: _dateOfTransit!,
        direction: _direction!,
        tmbCardNumber: _tmbCardNumberController.text,
        licensePlateNumber: _licensePlateNumberController.text,
        vehicleType: _vehicleType!,
        euroClass: _euroClass!,
        status: _status ?? Status.active,
      );

      if (widget.voucher == null) {
        ref.read(voucherProvider.notifier).addVoucher(newVoucher);
      } else {
        ref
            .read(voucherProvider.notifier)
            .updateVoucher(widget.voucher!, newVoucher);
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfTransit ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Set the primary color
            ),
            buttonTheme: const ButtonThemeData(
              textTheme:
                  ButtonTextTheme.primary, // Apply primary color to buttons
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfTransit) {
      setState(() {
        _dateOfTransit = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.voucher == null
              ? AppStrings.addVoucher
              : AppStrings.editVoucher,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<VoucherType>(
                decoration: InputDecoration(
                  labelText: AppStrings.voucherType,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _type,
                items: VoucherType.values.map((VoucherType type) {
                  return DropdownMenuItem<VoucherType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppStrings.selectVoucherTypeError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.voucherNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: _voucherNumberController,
                enabled: widget.voucher ==
                    null, // Disable this field if editing an existing voucher
                validator: (value) {
                  if (value == null || value.isEmpty || value.length > 20) {
                    return AppStrings.voucherNumberError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.tmbCardNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: _tmbCardNumberController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 10) {
                    return AppStrings.tmbCardNumberError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.licensePlateNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: _licensePlateNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length > 20) {
                    return AppStrings.licensePlateNumberError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Direction>(
                decoration: InputDecoration(
                  labelText: AppStrings.direction,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _direction,
                items: Direction.values.map((Direction direction) {
                  return DropdownMenuItem<Direction>(
                    value: direction,
                    child: Text(direction.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _direction = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppStrings.selectDirectionError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<VehicleType>(
                decoration: InputDecoration(
                  labelText: AppStrings.vehicleType,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _vehicleType,
                items: VehicleType.values.map((VehicleType type) {
                  return DropdownMenuItem<VehicleType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _vehicleType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppStrings.selectVehicleTypeError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EuroClass>(
                decoration: InputDecoration(
                  labelText: AppStrings.euroClass,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _euroClass,
                items: EuroClass.values.map((EuroClass euroClass) {
                  return DropdownMenuItem<EuroClass>(
                    value: euroClass,
                    child: Text(euroClass.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _euroClass = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppStrings.selectEuroClassError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.voucher != null)
                DropdownButtonFormField<Status>(
                  decoration: InputDecoration(
                    labelText: AppStrings.status,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _status,
                  items: Status.values.map((Status status) {
                    return DropdownMenuItem<Status>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              if (widget.voucher != null) const SizedBox(height: 16),
              TextFormField(
                readOnly: true, // Makes the field non-editable, only tappable
                decoration: InputDecoration(
                  labelText: 'Date of Transit',
                  hintText: AppStrings.selectDateOfTransit,
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: TextEditingController(
                  text: _dateOfTransit == null
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(_dateOfTransit!),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  widget.voucher == null
                      ? AppStrings.saveVoucher
                      : AppStrings.updateVoucher,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
