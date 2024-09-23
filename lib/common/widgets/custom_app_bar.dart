import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(VoucherFilter) onFilterSelected;

  const CustomAppBar({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(AppStrings.appTitle),  // Ensure AppStrings.appTitle is set properly
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),  // Adjust padding to prevent full toolbar coverage
          child: PopupMenuButton<VoucherFilter>(
            icon: SvgPicture.asset(
              AppAssets.filterIcon,
              height: 24,  // Specify height and width to avoid it expanding
              width: 24,
            ),
            onSelected: (value) {
              onFilterSelected(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: VoucherFilter.active,
                  child: _buildMenuItem(
                    icon: Icons.check_circle_outline,
                    color: AppColors.greenColor,
                    label: AppStrings.activeVouchers,
                  ),
                ),
                PopupMenuItem(
                  value: VoucherFilter.used,
                  child: _buildMenuItem(
                    icon: Icons.access_time,
                    color: AppColors.darkGreyColor,
                    label: AppStrings.usedVouchers,
                  ),
                ),
                PopupMenuItem(
                  value: VoucherFilter.all,
                  child: _buildMenuItem(
                    icon: Icons.list,
                    color: AppColors.greyColor,
                    label: AppStrings.allVouchers,
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(
      {required IconData icon, required Color color, required String label}) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
