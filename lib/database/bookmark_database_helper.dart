import 'dart:io';

import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/bookmark.dart';


class BookmarkHelper
{
  String tableName = "bookmarkedBooks";
  String bookmarkIdColumnName = "bookmarkId";

  BookmarkHelper.privateConstructor();

  static final BookmarkHelper instance = BookmarkHelper.privateConstructor();
  static Database? bdb;

  Future<Database> get database async
  {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bookmark.db");
    var exists = await databaseExists(path);
    if (!exists)
    {
      try
      {
        await Directory(dirname(path)).create(recursive: true);
      }
      catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "bookmark.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    else
    {

    }
    bdb = await openDatabase(path);
    return bdb!;
  }

  bookMarkBook(int bookmarkId) async
  {
    final bdb = await database;
    var response = await bdb.rawInsert("INSERT INTO bookmarkedBooks (bookmarkId)" "VALUES ($bookmarkId)");
    return response;
  }

  // DELETE BOOKMARK
  deleteBookFromBookMark(int bookmarkId) async
  {
    final bdb = await database;
    var response = await bdb.delete(tableName, where: '$bookmarkIdColumnName = ?', whereArgs: [bookmarkId]);
    return response;
  }

  // GET BOOKMARK
  Future<List<Bookmark>> getBookmarks() async
  {
    final bdb = await database;
    var response = await bdb.rawQuery("SELECT * FROM $tableName ");
    List<Bookmark> list = response.map((c) => Bookmark.fromJson(c)).toList();
    return list;
  }
}
