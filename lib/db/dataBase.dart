import "package:flutter/cupertino.dart";
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class DB {
  Database? _db;

  Future openDB() async {
    _db = await openDatabase(
      await join(await getDatabasesPath(), "ms24hs.db"),
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''  
          CREATE TABLE tipo(
            tp_id INTEGER PRIMARY KEY,
            tp_nombre TEXT,
            tp_nivel INTEGER,
            tp_vigente TEXT
          )
        ''');
      },
    );
  }
}
