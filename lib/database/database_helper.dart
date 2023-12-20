import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:srila_prabhupada_books/model/detail.dart';
import '../model/category.dart';

class DatabaseHelper
{
  String bookDetailsTable = "book_details";
  String bookID = "Book";
  String id = "Id";

  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  static Database? db;
  Future<Database> get database async
  {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "main_database.db");
    var exists = await databaseExists(path);
    if (!exists)
    {
      // THIS WILL INITIATE ONLY THE FIRST TIME WHEN YOU LAUNCH YOUR APPLICATION
      try
      {
        await Directory(dirname(path)).create(recursive: true);
      }
      catch (_) {}

      // COPY FROM ASSETS
      ByteData data = await rootBundle.load(join("assets", "main_database.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // WRITE AND FLUSH THE BYTES WRITTEN
      await File(path).writeAsBytes(bytes, flush: true);
    }
    else
    {
      // DB ALREADY EXISTS RETURN THE DATABASE
    }
    // OPEN THE DATABASE
    db = await openDatabase(path, readOnly: true);
    return db!;
  }

  // GET BOOKS
  Future<List<Books>> getBooks() async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM books");
    List<Books> list = response.map((c) => Books.fromJson(c)).toList();
    return list;
  }

  // GET A BOOK
  Future<Books> getBook(int bookID) async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM books WHERE Id = ? ", [bookID]);
    List<Books> list = response.map((c) => Books.fromJson(c)).toList();
    return list.first;
  }

  // GET CHAPTERS
  Future<List<BookDetail>> getBookChapters(int id) async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM $bookDetailsTable WHERE $bookID = ? ", [id]);
    debugPrint(response.toString());
    List<BookDetail> list = response.map((c) => BookDetail.fromJson(c)).toList();
    return list;
  }

  //GET DESCRIPTION
  Future<BookDetail> getChapterDescription(int id) async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM $bookDetailsTable WHERE Id = ? ", [id]);
    debugPrint(response.toString());
    List<BookDetail> list = response.map((c) => BookDetail.fromJson(c)).toList();
    return list.first;
  }

  Future<List<BookDetail>> getChapterDescriptions(int id) async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM $bookDetailsTable WHERE Id = ? ", [id]);
    debugPrint(response.toString());
    List<BookDetail> list = response.map((c) => BookDetail.fromJson(c)).toList();
    return list;
  }

  // GET SEARCH
  Future<List<BookDetail>> getSearch() async
  {
    final db = await database;
    var response = await db.rawQuery("SELECT * FROM $bookDetailsTable");
    debugPrint(response.toString());
    List<BookDetail> list = response.map((c) => BookDetail.fromJson(c)).toList();
    return list;
  }
}
