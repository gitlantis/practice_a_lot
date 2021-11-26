import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:practicealot/models/cathegory.dart';
import 'package:practicealot/models/equation.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String cathegoryTable = 'cathegories';
  String colCathId = 'id';
  String colCathName = 'name';

  String equationTable = 'equations';
  String colEqId = 'id';
  String colCathEqId = 'cath_id';
  String colEqTitle = 'equation_title';
  String colEqContent = 'equation_content';
  String colEqIsSolved = 'is_solved';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    //Get the directory for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/_practicealot.db';
    await deleteDatabase(path);

// Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load("assets/practicealot.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

    //Open/create the database at a given path
    var practicealotDatabase = await openDatabase(path);
    return practicealotDatabase;
  }

  Future<List<Map<String, dynamic>>> getCathegoryMapList() async {
    Database db = await this.database;
    var result = await db.query(cathegoryTable, orderBy: '$colCathId ASC');
    return result;
  }

  Future<List<Cathegory>> getCathegory() async {
    var cathList = await getCathegoryMapList(); // Get 'Map List' from database
    int count = cathList.length; // Count the number of map enteries in db table

    List<Cathegory> cathegoryListView = List<Cathegory>();
    // for loop to create a 'Note List' from 'Map List'
    for (int i = 0; i < count; i++) {
      cathegoryListView.add(Cathegory.fromMapObject(cathList[i]));
    }

    return cathegoryListView;
  }

  Future<List<Map<String, dynamic>>> getEquationsByCathId(int id) async {
    Database db = await this.database;
    var result = await db.query(equationTable,
        orderBy: '$colEqIsSolved DESC',
        where: '$colCathEqId = ?',
        whereArgs: [id]);
    return result;
  }

  Future<List<Equation>> getEquation(int id) async {
    var eqList = await getEquationsByCathId(id); // Get 'Map List' from database
    int count = eqList.length; // Count the number of map enteries in db table

    List<Equation> eqListView = List<Equation>();
    // for loop to create a 'Note List' from 'Map List'
    for (int i = 0; i < count; i++) {
      eqListView.add(Equation.fromMapObject(eqList[i]));
    }

    return eqListView;
  }

  Future<List<Map<String, dynamic>>> getEquationById(int id) async {
    Database db = await this.database;
    var result = await db.query(equationTable,
        orderBy: '$colEqId ASC', where: '$id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCathegoryCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $cathegoryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getEquationCount(int id) async {
    Database db = await this.database;

    String query = id != null
        ? 'SELECT COUNT (*) FROM $equationTable WHERE cath_id=$id'
        : 'SELECT COUNT (*) FROM $equationTable';

    List<Map<String, dynamic>> x = await db.rawQuery(query);
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
