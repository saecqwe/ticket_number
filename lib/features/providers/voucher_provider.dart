import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voucher.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/constants/app_enums.dart';

class VoucherNotifier extends StateNotifier<List<Voucher>> {
  final LocalStorageService _localStorageService = LocalStorageService();
  VoucherFilter _filter = VoucherFilter.all;
  List<Voucher> _allVouchers = []; // Store all vouchers

  VoucherNotifier() : super([]) {
    _initDB();
  }

  Future<void> _initDB() async {
    await _localStorageService.initDB();
    await fetchAndSetVouchers();
  }

  Future<void> fetchAndSetVouchers() async {
    _allVouchers =
        await _localStorageService.fetchVouchers(); // Initialize _allVouchers
    state = _filteredVouchers(); // Apply the initial filter
    print("abdullah all vouchers length ; ${_allVouchers.length}");
  }

  Future<void> addVoucher(Voucher voucher) async {
    await _localStorageService.addVoucher(voucher);
    _allVouchers = [..._allVouchers, voucher]; // Update _allVouchers
    state = _filteredVouchers(); // Apply the filter
  }

  Future<void> updateVoucher(Voucher oldVoucher, Voucher newVoucher) async {
    await _localStorageService.updateVoucher(oldVoucher, newVoucher);
    _allVouchers = [
      for (final voucher in _allVouchers)
        if (voucher.voucherNumber == oldVoucher.voucherNumber)
          newVoucher
        else
          voucher,
    ];
    state = _filteredVouchers(); // Apply the filter
  }

  Future<void> deleteVoucher(Voucher voucher) async {
    await _localStorageService.deleteVoucher(voucher.voucherNumber);
    _allVouchers = _allVouchers
        .where((v) => v.voucherNumber != voucher.voucherNumber)
        .toList();
    state = _filteredVouchers(); // Apply the filter
  }

  void setFilter(VoucherFilter filter) {
    _filter = filter;
    state = _filteredVouchers(); // Apply the filter
  }

  List<Voucher> _filteredVouchers() {
    switch (_filter) {
      case VoucherFilter.active:
        return _allVouchers
            .where((voucher) => voucher.status == Status.active)
            .toList();
      case VoucherFilter.used:
        return _allVouchers
            .where((voucher) => voucher.status == Status.used)
            .toList();
      case VoucherFilter.all:
      default:
        return _allVouchers;
    }
  }

}

final voucherProvider =
    StateNotifierProvider<VoucherNotifier, List<Voucher>>((ref) {
  return VoucherNotifier();
});
