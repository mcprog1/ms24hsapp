import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ms24hs/models/tipo.dart';
import 'package:ms24hs/models/valores.dart';
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/subCategorias.dart';

class DB {
  Database? _db;

  /** ARMADO DE LA BASE DE DATOS */
  Future openDB() async {
    // ignore: prefer_conditional_assignment
    if (_db == null) {
      _db = await openDatabase(
        await join(await getDatabasesPath(), "ms24hs.db"),
        version: 2,
        onCreate: (Database db, int version) async {
          /** TABLA DE TIPO */
          print("tipo");
          await db.execute('''  
          CREATE TABLE tipo(
            tp_id INTEGER PRIMARY KEY,
            tp_nombre TEXT,
            tp_nivel INTEGER,
            tp_vigente TEXT
          )
        ''');
          print("valores");
          /** TABLA DE VALORES */
          await db.execute('''  
          CREATE TABLE valores(
            vl_tp_id INTEGER,
            vl_id INTEGER,
            vl_nombre TEXT,
            vl_valor TEXT,
            vl_valor1 TEXT,
            vl_vigente TEXT
          )
        ''');
        },
      );
    }
    await cargarTablasNuevas(_db);
  }

  Future<void> cargarTablasNuevas(Database? db) async {
    /** TABLA DE CATEGORIAS */
    await db!.execute('''  
          CREATE TABLE IF NOT EXISTS categorias(
            idCategoria INTEGER PRIMARY KEY,
            nombreCategoria TEXT,
            urlImagen TEXT,
            tipoCategoria INTEGER,
            vigente TEXT
          )
        ''');
    /** TABLA DE SUB-CATEGORIAS */
    await db.execute('''  
          CREATE TABLE IF NOT EXISTS sub_categorias(
            subcatId INTEGER,
            subcatCatId INTEGER,
            subcatNombre TEXT,
            subcatVigente TEXT
          )
        ''');
  }

  Future<int> insertSubCategoria(SubCategorias sub) async {
    print("Insert sub categoria");
    await openDB();
    return await _db!.insert('sub_categorias', sub.toJson());
  }

  Future<int> insertCategoria(Categorias cat) async {
    // print("Insert categoria");
    await openDB();
    return await _db!.insert('categorias', cat.toJson());
  }

  Future<int> insertTipo(DatosTpWs tp) async {
    print("Insert tipo");
    await openDB();
    return await _db!.insert("tipo", tp.toJson());
  }

  Future<int> insertValores(DatosVl vl) async {
    print("Insert valores");
    await openDB();
    return await _db!.insert("valores", vl.toJson());
  }

  Future<int> eliminarTipo() async {
    print("delete Types");
    await openDB();
    return await _db!.rawDelete("DELETE FROM tipo");
  }

  Future<int> eliminarValores() async {
    print("delete Types");
    await openDB();
    return await _db!.rawDelete("DELETE FROM valores");
  }

  Future<int> eliminarCategoria() async {
    print("delete Category");
    await openDB();
    return await _db!.rawDelete("DELETE FROM categorias");
  }

  Future<int> eliminarSubCategoria() async {
    print("delete Sub Categoty");
    await openDB();
    return await _db!.rawDelete("DELETE FROM sub_categorias");
  }

  Future<List<DatosVl>> getDias() async {
    print("getDias");
    await openDB();
    final List<Map<String, dynamic>> maps =
        await _db!.rawQuery("SELECT * FROM valores WHERE vl_tp_id = 9");
    return List.generate(
        maps.length,
        (i) => DatosVl(
            vlTpId: maps[i]["vl_tp_id"],
            vlId: maps[i]["vl_id"],
            vlNombre: maps[i]["vl_nombre"],
            vlValor1: maps[i]["vl_valor"],
            vlValor: maps[i]["vl_valor1"],
            vlVigente: maps[i]["vl_vigente"]));
  }

  Future<List<DatosVl>> getHoras() async {
    print("getHoras");
    await openDB();
    final List<Map<String, dynamic>> maps =
        await _db!.rawQuery("SELECT * FROM valores WHERE vl_tp_id = 10");
    return List.generate(
        maps.length,
        (i) => DatosVl(
            vlTpId: maps[i]["vl_tp_id"],
            vlId: maps[i]["vl_id"],
            vlNombre: maps[i]["vl_nombre"],
            vlValor1: maps[i]["vl_valor"],
            vlValor: maps[i]["vl_valor1"],
            vlVigente: maps[i]["vl_vigente"]));
  }

  Future<List<SubCategorias>> getSubCategoria() async {
    print("getSubCategoria");
    await openDB();
    final List<Map<String, dynamic>> maps =
        await _db!.rawQuery("SELECT * FROM sub_categorias");
    return List.generate(
        maps.length,
        (i) => SubCategorias(
            subcatCatId: maps[i]['subcatCatId'],
            subcatId: maps[i]['subcatId'],
            subcatNombre: maps[i]['subcatNombre'],
            subcatVigente: maps[i]['subCatVigente']));
  }

  Future<List<Categorias>> getCategorias() async {
    print("getCategorias");
    await openDB();
    final List<Map<String, dynamic>> maps =
        await _db!.rawQuery("SELECT * FROM categorias");
    return List.generate(
        maps.length,
        (i) => Categorias(
            idCategoria: maps[i]["idCategoria"],
            nombreCategoria: maps[i]["nombreCategoria"],
            tipoCategoria: maps[i]["tipoCategoria"],
            urlImagen: maps[i]["urlImagen"],
            vigente: maps[i]["vigente"]));
  }
}
