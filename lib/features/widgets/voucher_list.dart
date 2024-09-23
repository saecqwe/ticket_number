import 'package:flutter/material.dart';
import '../models/voucher.dart';
import '../screens/addVoucher/add_voucher_screen.dart';
import 'voucher_item.dart';
import '../../core/constants/app_strings.dart';

class VoucherList extends StatelessWidget {
  final List<Voucher> vouchers;

  VoucherList({required this.vouchers});

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.noVoucherAvailable,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVoucherScreen()),
                );
              },
              child: Text(AppStrings.addVoucher),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          return VoucherItem(voucher: vouchers[index]);
        },
      );
    }
  }
}
