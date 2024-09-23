import 'package:ticket_number/core/constants/app_strings.dart';
import 'package:ticket_number/core/constants/app_enums.dart';

class Voucher {
  // Mandatory fields for all vouchers
  final VoucherType type;
  final String tmbCardNumber; // no use for this release
  final String voucherNumber; // only numeric 10 to 15 chars
  final String licensePlateNumber; // no spaces allowed
  Status status;

  // Fields for tunnelMontBlanc
  final Direction direction; // mandatory
  final DateTime dateOfTransit; // mandatory
  final String driveName; // optional default value: Unknown Driver
  final String companyName; // optional default value: UNION TANK

  // Fields for tunnelFrejus
  final VehicleType vehicleType; // mandatory
  final EuroClass euroClass; // optional default value: all
  final VehicleClass
      vehicleClass; // Optional, Default Value for bus: class4, Default Value for truck: all
  final DateTime expiryDate; // optional default value: today+1 year

  Voucher({
    required this.voucherNumber,
    required this.type,
    required this.dateOfTransit,
    required this.licensePlateNumber,
    this.tmbCardNumber = '',
    this.status = Status.active,
    this.driveName = AppStrings.defaultDriveName,
    this.companyName = AppStrings.defaultCompanyName,
    required this.vehicleType,
    this.euroClass = EuroClass.all,
    this.vehicleClass = VehicleClass.all,
    DateTime? expiryDate,
    required this.direction,
  })  :expiryDate = expiryDate ??
            DateTime.now()
                .add(const Duration(days: 365)); // default to today + 1 year

  // Optional method to update the voucher status
  void updateStatus(Status newStatus) {
    status = newStatus;
  }
}
