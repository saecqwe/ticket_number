import 'package:flutter/material.dart';
import '../models/voucher.dart';
import '../providers/voucher_provider.dart';
import '../screens/voucher_details_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_enums.dart';
import '../screens/edit_voucher_screen.dart';


class VoucherItem extends ConsumerWidget {
  final Voucher voucher;

  const VoucherItem({super.key, required this.voucher});

  // Method to get the appropriate icon based on voucher type
  Widget _getVoucherIcon(VoucherType type) {
    switch (type) {
      case VoucherType.tunnelMontBlanc:
        return SvgPicture.asset(
          'assets/images/logo_tmb.svg', // Replace with actual SVG asset path
          width: 40.0, // Adjust icon size as needed
          height: 40.0,
        );
      case VoucherType.tunnelFrejus:
        return SvgPicture.asset(
          'assets/images/logo_sftrf.svg', // Replace with actual SVG asset path
          width: 40.0, // Adjust icon size as needed
          height: 40.0,
        );
      default:
        return SvgPicture.asset(
          'assets/images/logo_sftrf.svg', // Replace with actual SVG asset path for fallback
          width: 40.0, // Adjust icon size as needed
          height: 40.0,
        );
    }
  }

  // Method to get status color based on voucher status
  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.active:
        return Colors.green;
      case Status.expired:
        return Colors.red;
      case Status.used:
        return Colors.grey;
      default:
        return Colors.blue; // Default color
    }
  }

  // Method to get the route from the direction enum
  String _getRoute(Direction direction) {
    switch (direction) {
      case Direction.italyToFrance:
        return 'Italy ➔ France';
      case Direction.franceToItaly:
        return 'France ➔ Italy';
      default:
        return 'Unknown Route';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(voucher.voucherNumber),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              ref
                  .read(voucherProvider.notifier)
                  .updateVoucher(voucher, voucher..status = Status.used);
            },
            backgroundColor: Colors.green.withOpacity(0.9),
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Used',
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditVoucherScreen(voucher: voucher,),
              ));
            },
            backgroundColor: Colors.blue.withOpacity(0.9),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          SlidableAction(
            onPressed: (context) {
              ref.read(voucherProvider.notifier).deleteVoucher(voucher);
            },
            backgroundColor: Color(0xFFFF220F), // Use your primary color
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VoucherDetailsScreen(voucher: voucher),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Center content vertically
              children: [
                Column(
                  children: [
                    // Use SizedBox to control the size of the SVG icon
                    SizedBox(
                      width: 40, // Adjust the size as needed
                      height: 40, // Adjust the size as needed
                      child: _getVoucherIcon(voucher.type),
                    ),
                    const SizedBox(height: 12), // Add some space between icon and dot
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: _getStatusColor(voucher.status),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center-align text horizontally
                    children: [
                      Text(
                        DateFormat('dd.MM.yyyy').format(voucher.dateOfTransit),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8), // Increase vertical space between text items
                      Text(
                        _getRoute(voucher.direction),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8), // Increase vertical space between text items
                      Text(
                        voucher.voucherNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
