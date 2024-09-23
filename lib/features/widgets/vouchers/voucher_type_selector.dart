import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme.dart';
import 'package:ticket_number/core/constants/app_enums.dart';

class VoucherTypeSelector extends StatelessWidget {
  final void Function(VoucherType) onTypeSelected;

  VoucherTypeSelector({required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the size of the square views (keeping them equal width and height)
    double squareSize =
        screenWidth * 0.4; // 40% of the screen width for square views

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16), // Space below the toolbar
              Center(
                child: Text(
                  AppStrings.chooseVoucherType,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.1), // Space between text and square views
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeOption(
                      context,
                      VoucherType.tunnelMontBlanc,
                      AppStrings.tunnelMontBlanc,
                      squareSize,
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.1), // Spacing between the two square views
                    _buildTypeOption(
                      context,
                      VoucherType.tunnelFrejus,
                      AppStrings.tunnelFrejus,
                      squareSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption(
      BuildContext context, VoucherType type, String label, double size) {
    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Container(
        height: size,
        width: size, // Make the container square
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(3, 3),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car,
                size: size * 0.3), // Icon size based on the square size
            SizedBox(height: 8),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge), // Adjust text size based on square size
          ],
        ),
      ),
    );
  }
}
