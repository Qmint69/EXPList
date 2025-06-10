import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/kontak.dart';

class DbHelper {
  static const String tableName = 'kontak';
  static const String hiveBoxName = 'kontakBox';

  Database? _database;
  Box? _box;

  Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
      _box = await Hive.openBox(hiveBoxName);
    } else {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'kontak.db');

      _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            mobileNo TEXT,
            company TEXT
          )
        ''');
      });
    }
  }

  Future<List<Map<String, dynamic>>?> getAllKontak() async {
    if (kIsWeb) {
      await init();
      return _box!.toMap().entries.map((e) {
        Map<String, dynamic> map = Map<String, dynamic>.from(e.value);
        map['id'] = e.key;
        return map;
      }).toList();
    } else {
      await init();
      return await _database!.query(tableName);
    }
  }

  Future<int> insertKontak(Kontak kontak) async {
    await init();
    if (kIsWeb) {
      int key = await _box!.add(kontak.toMap());
      return key;
    } else {
      return await _database!.insert(tableName, kontak.toMap());
    }
  }

  Future<int> updateKontak(Kontak kontak) async {
    await init();
    if (kIsWeb) {
      await _box!.put(kontak.id, kontak.toMap());
      return 1;
    } else {
      return await _database!.update(
        tableName,
        kontak.toMap(),
        where: 'id = ?',
        whereArgs: [kontak.id],
      );
    }
  }

  Future<int> deleteKontak(int id) async {
    await init();
    if (kIsWeb) {
      await _box!.delete(id);
      return 1;
    } else {
      return await _database!.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
