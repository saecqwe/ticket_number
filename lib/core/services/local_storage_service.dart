import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/models/voucher.dart';
import 'package:ticket_number/core/constants/app_enums.dart';

class LocalStorageService {
  late Database _database;

  Future<void> initDB() async {
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'vouchers.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE vouchers(id TEXT PRIMARY KEY, voucherNumber TEXT, type TEXT, dateOfTransit TEXT, direction TEXT, tmbCardNumber TEXT, licensePlateNumber TEXT, vehicleType TEXT, euroClass TEXT, status TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Voucher>> fetchVouchers() async {
    final dataList = await _database.query('vouchers');
    return dataList
        .map((item) => Voucher(
              voucherNumber: item['voucherNumber'] as String,
              type: VoucherType.values
                  .firstWhere((e) => e.toString() == item['type']),
              dateOfTransit: DateTime.parse(item['dateOfTransit'] as String),
              direction: Direction.values
                  .firstWhere((e) => e.toString() == item['direction']),
              tmbCardNumber: item['tmbCardNumber'] as String,
              licensePlateNumber: item['licensePlateNumber'] as String,
              vehicleType: VehicleType.values
                  .firstWhere((e) => e.toString() == item['vehicleType']),
              euroClass: EuroClass.values
                  .firstWhere((e) => e.toString() == item['euroClass']),
              status: Status.values
                  .firstWhere((e) => e.toString() == item['status']),
            ))
        .toList();
  }

  Future<void> addVoucher(Voucher voucher) async {
    int result = await _database.insert(
      'vouchers',
      {
        'id': voucher.voucherNumber,
        'voucherNumber': voucher.voucherNumber,
        'type': voucher.type.toString(),
        'dateOfTransit': voucher.dateOfTransit.toIso8601String(),
        'direction': voucher.direction.toString(),
        'tmbCardNumber': voucher.tmbCardNumber,
        'licensePlateNumber': voucher.licensePlateNumber,
        'vehicleType': voucher.vehicleType.toString(),
        'euroClass': voucher.euroClass.toString(),
        'status': voucher.status.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<void> updateVoucher(Voucher oldVoucher, Voucher newVoucher) async {
    await _database.update(
      'vouchers',
      {
        'voucherNumber': newVoucher.voucherNumber,
        'type': newVoucher.type.toString(),
        'dateOfTransit': newVoucher.dateOfTransit.toIso8601String(),
        'direction': newVoucher.direction.toString(),
        'tmbCardNumber': newVoucher.tmbCardNumber,
        'licensePlateNumber': newVoucher.licensePlateNumber,
        'vehicleType': newVoucher.vehicleType.toString(),
        'euroClass': newVoucher.euroClass.toString(),
        'status': newVoucher.status.toString(),
      },
      where: 'id = ?',
      whereArgs: [oldVoucher.voucherNumber],
    );
  }

  Future<void> deleteVoucher(String voucherId) async {
    await _database.delete(
      'vouchers',
      where: 'id = ?',
      whereArgs: [voucherId],
    );
  }
}
