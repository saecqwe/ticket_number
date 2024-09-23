import 'package:flutter/material.dart';
import 'package:ticket_number/core/services/navigation_service.dart';
import '../../../core/constants/app_colors.dart';
import 'voucher_input_sheet.dart';
import 'package:ticket_number/core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/vouchers/voucher_type_selector.dart';

class AddVoucherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                NavigationService().navigateToHome();
              },
              icon: Icon(Icons.abc))
        ],
        title: Text(AppStrings.addVoucher),
      ),
      body: VoucherTypeSelector(
        onTypeSelected: (VoucherType type) {
          // Open Bottom Sheet when a user selects the voucher type
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => VoucherInputSheet(voucherType: type),
          );
        },
      ),
    );
  }
}
