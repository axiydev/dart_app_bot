import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

class HiveDB {
  static Future<void> setupHive() async {
    Directory dir = Directory.systemTemp;
    String dbPath = join(dir.path, 'assets', 'db');
    print(dir);
    print(dbPath);

    Hive.init(dbPath);

    await Hive.openBox("data_db");

    print("database inited....");
  }
}
