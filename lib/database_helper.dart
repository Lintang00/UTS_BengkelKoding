import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:uts_todo_list/todo.dart';

// "class databaseHelper" digunakan untuk koneksi dan mengatur query
class DatabaseHelper {
  // pola singleton yang berguna untuk digunakan dalam beberapa page
  // singleton pattern berfungsi untuk memastikan bahwa koneksi database
  // hanya ada satu dalam aplikasi
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db; // untuk koneksi ke sqlite-nya

  // "get db" berguna untuk mengecek apakah database sudah ada atau belum,
  // jika belum ada, maka akan memanggil "initDb()" dan
  // membuat database/directory baru
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  // "initDb" berfungsi untuk membuat koneksi, membuat database-nya,
  // meletakkan posisi path-nya, dan menentukan versinya
  // -> "version" berguna untuk memastikan aplikasi berubah,
  //     seperti menambahkan kolom tabel baru pada aplikasi todo list ini
  Future<Database> initDb() async {
    io.Directory docDirecory = await getApplicationDocumentsDirectory();
    String path = join(docDirecory.path, "todolist.db");
    var localDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    ).catchError((e) => print("error opening database:$e"));
    return localDb;
  }

  // fungsi ini akan di eksekusi ketika "onCreate" belum ada database-nya
  // maka fungsi ini akan membuat tabel database untuk menyimpan data yang akan diinputkan
  void _onCreate(Database db, int version) async {
    await db.execute('''
        create table if not exists todos(
          id integer primary key autoincrement,
          nama text not null,
          deskripsi text not null,
          done integer not null default 0 
        )''');
  }

  // ============ CRUD ============
  Future<List<Todo>> getAllTodos() async {
    var dbClient = await db;
    var todos = await dbClient!.query('todos');
    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<List<Todo>> searchTodo(String keyword) async {
    var dbClient = await db;
    var todos = await dbClient!.query(
      'todos',
      where: 'nama like ?',
      whereArgs: ['%$keyword%'],
    );
    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<int> addTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
