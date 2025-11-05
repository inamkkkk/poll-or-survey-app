import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:poll_app/models/poll.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'polls.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE polls (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, options TEXT, votes TEXT)',
    );
  }

  Future<List<Poll>> getPolls() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('polls');
    return List.generate(maps.length, (i) {
      return Poll.fromMap(maps[i]);
    });
  }

  Future<int> insertPoll(Poll poll) async {
    final db = await database;
    return await db.insert('polls', poll.toMap());
  }

  Future<int> updatePoll(Poll poll) async {
    final db = await database;
    return await db.update(
      'polls',
      poll.toMap(),
      where: 'id = ?',
      whereArgs: [poll.id],
    );
  }

  Future<int> deletePoll(int id) async {
    final db = await database;
    return await db.delete(
      'polls',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}