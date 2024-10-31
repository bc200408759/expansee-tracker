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
      print("Database initilized");
      return _database!;
    } catch(exception) {
      print("Error while opening database");
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
      print("Can't initilize database: $exception");
      throw Exception("Failed! Reason: $exception");
    }
  }

  Future _onCreate(Database database, int version) async {
    print("creating tables");
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

        print("Database Table: 'User' & 'FinancialEntries' created");
      } catch (exception) {
        print("Table creation failed");
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
      print("error while saving the user: $exception");
    }
    print("user ${user.Name} added to database");
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
      print("error while updating user: $exception");
    }
    print("user ${user.Name} updated to database");
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
      print("error while deleting the user: $exception");
    }
    print("user with id $id deleted from database");
  }
  
  Future<List<User>> getUserList() async {
    final database_ = await database;
    List<Map<String, dynamic>> resultList;
    try {
      resultList = await database_.query(
        'Users',
      ); 
      
      print("user list retrived");
      return resultList.map((json) => User.fromMap(json)).toList();
    } catch(exception) {
      print("error while retriving user list with error: $exception");
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
    print("Entry ${entry.title} added to database with user id: ${entry.userId}");
    } catch (exception) {
      print("error while saving the entry: $exception");
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
    
      print("list with userId $id retrived from database");
      return resultList.map((json) => FinancialEntry.fromMap(json)).toList();
      
    } catch (exception) {
      print("error while fetching the list: $exception");
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
      print("user $categoryName  with type ${type.name} added to database");
    } catch (exception) {
      print("error while add category $categoryName to databse: $exception");
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
      print("category $newName updated to database");
    } catch (exception) {
      print("error while updating $category: $exception");
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
      print("Category $category deleted from database");
    } catch (exception) {
      print("error while deleting the category: $exception");
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
      
      print("user list retrived");
      return resultList.map((row) => row['categoryName'] as String).toList();
    } catch(exception) {
      print("error while retriving user list with error: $exception");
    }
    return List.empty();
  }
}

