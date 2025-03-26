import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  late Database _database;

  DatabaseHelper._internal();

  static Future<DatabaseHelper> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
      await _instance!._initDatabase();
    }
    return _instance!;
  }

  Future<void> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'company_details.db');

    _database = sqlite3.open(path);
    _createTable();
  }

  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS company (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT,
        phone TEXT,
        gst TEXT,
        bank_name TEXT,
        account_number TEXT,
        ifsc_code TEXT
      )
    ''');
  }

  Future<void> insertOrUpdateCompany(Map<String, String> companyData) async {
    _database.execute('DELETE FROM company'); // Keep only one record
    _database.execute('''
      INSERT INTO company (name, address, phone, gst, bank_name, account_number, ifsc_code) 
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      companyData['name'],
      companyData['address'],
      companyData['phone'],
      companyData['gst'],
      companyData['bank_name'],
      companyData['account_number'],
      companyData['ifsc_code'],
    ]);
  }

  Future<Map<String, String>?> getCompanyDetails() async {
    final result = _database.select('SELECT * FROM company LIMIT 1');
    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'name': row['name'] as String,
        'address': row['address'] as String,
        'phone': row['phone'] as String,
        'gst': row['gst'] as String,
        'bank_name': row['bank_name'] as String,
        'account_number': row['account_number'] as String,
        'ifsc_code': row['ifsc_code'] as String,
      };
    }
    return null;
  }
}
