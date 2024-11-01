//class that interacts with database and manage store and retrival of data

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/financial_entry.dart';


class DatabaseController {
  static final DatabaseController controller = DatabaseController._internal();

  factory DatabaseController() => controller;

  static Database? _database;

  DatabaseController._internal();

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    try {
      _database = await initDatabase();

      return _database!;
    } catch(exception) {

      throw Exception("Initiliation Error $exception");
    }
  }

  Future<Database> initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "user_database.db");

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (exception) {

      throw Exception("Failed! Reason: $exception");
    }
  }

  Future _onCreate(Database database, int version) async {

      try {
      await database.execute('''
        CREATE TABLE Users (
          id TEXT PRIMARY KEY,
          name TEXT
        )
      ''');
      await database.execute('''
        CREATE TABLE FinancialEntries (
          id String PRIMARY KEY,
          title TEXT,
          amount REAL NOT NULL,
          type TEXT NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          details TEXT,
          userId TEXT,
          FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE
        )
      ''');
      await database.execute('''
        CREATE TABLE TransectionsCategories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          categoryName TEXT NOT NULL
        )
      ''');


      } catch (exception) {

        throw Exception("Table creation failed: $exception");
      }
  }

  Future<bool> isTableExist(String tableName) async {
    final database_ = await database;
    final result = await database_.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName]
    );
    return result.isNotEmpty;
  }

  Future<void> addUser(User user) async {
    final database_ = await database;
    try {
        
      await database_.insert(
        'Users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (exception) {
      // throw Exception("Error while adding User $exception");
    }

  }

  Future<void> updateUser(User user) async {
    final database_ = await database;
    try {
        
      await database_.update(
        'Users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (exception) { 
      //Noting to do
       }
  }
  
  Future<void> deleteUser(String id) async {
    final database_ = await database;
    try {
      await database_.delete(
        'Users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (exception) {
      throw Exception("Error while deleting User $exception");    }
  }
  
  Future<User> getUser(String id) async {
    final database_ = await database;
    List<Map<String, dynamic>> result;
    try {
      result = await database_.query(
        'Users',
        where: 'id = ?',
        whereArgs: [id]
      ); 
      
      return result.map((json) => User.fromMap(json)).toList().first;
    } catch(exception) {
      //Nothing to do
    }
    return User.loadUser(name:"", id: "");
  }


  Future<List<User>> getUserList() async {
    final database_ = await database;
    List<Map<String, dynamic>> resultList;
    try {
      resultList = await database_.query(
        'Users',
      ); 
      
      return resultList.map((json) => User.fromMap(json)).toList();
    } catch(exception) {
      //Nothing to do
    }
    return List.empty();
  }


  Future<void> addFinancialEntry(FinancialEntry entry) async {
    final database_ = await database;
    try {
      await database_.insert(
        'FinancialEntries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (exception) {
      //Nothing to do
    }
  }


  Future<List<FinancialEntry>> fetchFinancialEntries(String id) async {
    final database_ = await database;
    List<Map<String, dynamic>> resultList;
    try {
      resultList = await database_.query(
        'FinancialEntries',
        where: 'userId = ?',
        whereArgs: [id],
      );
    
      return resultList.map((json) => FinancialEntry.fromMap(json)).toList();
      
    } catch (exception) {
      //Nothing to do 
    }
    return List.empty();
  }


  Future<void> addCategory(String categoryName, EntryType type) async {
    final database_ = await database;
    try {
      await database_.insert(
        'TransectionsCategories',
        {
          'categoryName': categoryName,
          'type': type.name
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (exception) {
      //Nothing do to
    }
  }

  Future<void> updateCategory(String category, String newName) async {
    final database_ = await database;
    try {
        
      await database_.update(
        'TransectionsCategories',
        {'categoryName': newName},
        where: 'categoryName = ?',
        whereArgs: [category],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (exception) {
      //Nothing to do
    }
  }
  
  Future<void> deleteCategory(String category) async {
    final database_ = await database;
    try {
      await database_.delete(
        'TransectionsCategories',
        where: 'categoryName = ?',
        whereArgs: [category],
      );

    } catch (exception) {
      //Nothing to do
    }
  }

  Future<List<String>> getCagetoriesWithType(EntryType type) async {
    final database_ = await database;
    List<Map<String, dynamic>> resultList;
    try {
      resultList = await database_.query(
        'TransectionsCategories',
        where: 'type = ?',
        whereArgs: [type.name],
      ); 
      
      return resultList.map((row) => row['categoryName'] as String).toList();
    } catch(exception) {
      //Nothing todo 
    }
    return List.empty();
  }
}

