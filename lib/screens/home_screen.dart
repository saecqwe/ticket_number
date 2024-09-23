import 'package:flutter/material.dart';
import 'package:ticket_number/core/constants/app_colors.dart';
import '../features/providers/voucher_provider.dart';
import '../features/widgets/voucher_list.dart';
import '../common/widgets/custom_app_bar.dart';
import '../common/widgets/side_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchers = ref.watch(voucherProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(onFilterSelected: (filter) {
        ref.read(voucherProvider.notifier).setFilter(filter);
      }),
      drawer: SideMenu(),
      body: vouchers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SVG Icon
                  SvgPicture.asset(
                    'assets/images/no_voucher_icon.svg', // Ensure you have the SVG in your assets folder
                    height: 150, // Adjust size as needed
                  ),
                  const SizedBox(height: 24), // Space between the icon and text
                  // Text
                  Text(
                    AppStrings
                        .noVoucherAvailable, // Fetch string from AppStrings
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppColors.primaryTextColor),
                  ),
                  const SizedBox(height: 16), // Space between text and button
                  // Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add-voucher');
                    },
                    child: const Text(AppStrings.addVoucher),
                  ),
                ],
              ),
            )
          : VoucherList(vouchers: vouchers),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            right: 16.0, bottom: 16.0), // Adjust padding as needed
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/add-voucher');
          },
          child: const Icon(
            Icons.add,
            size: 32.0, // Adjust icon size as needed
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Positioning of the FAB
    );
  }
}
