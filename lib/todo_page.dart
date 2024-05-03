import 'package:flutter/material.dart';
import 'package:uts_todo_list/database_helper.dart';
import 'package:uts_todo_list/todo.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  String tanggalHariIni = DateFormat('EEEE, MMMM y').format(DateTime.now());
  TextEditingController _namaCtrl = TextEditingController();
  TextEditingController _deskripsiCtrl = TextEditingController();
  TextEditingController _searchCtrl = TextEditingController();
  List<Todo> todoList = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    final todos = await dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });
  }

  void additem() async {
    await dbHelper.addTodo(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    // todoList.add(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    refreshList();

    _namaCtrl.text = '';
    _deskripsiCtrl.text = '';
  }

  void updateItem(int index, bool done) async {
    todoList[index].done = done;
    await dbHelper.updateTodo(todoList[index]);
    refreshList();
  }

  void deleteItem(int id) async {
    // todoList.removeAt(index);
    await dbHelper.deleteTodo(id);
    refreshList();
  }

  void cariTodo() async {
    String teks = _searchCtrl.text.trim();
    List<Todo> todos = [];
    if (teks.isEmpty) {
      todos = await dbHelper.getAllTodos();
    } else {
      todos = await dbHelper.searchTodo(teks);
    }

    setState(() {
      todoList = todos;
    });
  }

  void tampilForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xffFFFDF3),
        insetPadding: EdgeInsets.all(20),
        title: Text(
          "Buat Jadwal",
          style: TextStyle(
              color: Color(0xff5E6C2F),
              fontWeight: FontWeight.w700,
              fontSize: 22),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                        color: Color(0xff5E6C2F),
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xffFFFDF3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: Color(0xff5E6C2F))))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "Tambah",
                    style: TextStyle(
                        color: Color(0xff5E6C2F),
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xffCCD5AE)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ))),
                  onPressed: () {
                    additem();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ],
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.225,
          child: Column(
            children: [
              TextField(
                controller: _namaCtrl,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 4.0,
                      borderSide:
                          BorderSide(color: Color(0xff5E6C2F), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Jadwal hari ini",
                    hintStyle: TextStyle(color: Colors.blueGrey)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _deskripsiCtrl,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 4.0,
                      borderSide:
                          BorderSide(color: Color(0xff5E6C2F), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: '''Deskripsikan kegiatan anda
                    
                    
                    
                    ''',
                    hintStyle: TextStyle(color: Colors.grey),
                    hintMaxLines: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffCCD5AE),
        title: Text(
          "Jadwal Kegiatan",
          style: TextStyle(color: Color(0xff5E6C2F)),
        ),
        // centerTitle: true,
      ),
      body: Container(
        color: Color(0xffFFFDF3),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari",
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 4.0,
                    borderSide:
                        BorderSide(color: Color(0xff5E6C2F), width: 1.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                controller: _searchCtrl,
                onChanged: (_) {
                  cariTodo();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Text(
                tanggalHariIni,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xff5E6C2F),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffF0F2DC),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600.withOpacity(
                              0.5), // Warna bayangan dan opasitasnya
                          spreadRadius: 0.5, // Persebaran bayangan
                          blurRadius: 3, // Radius blur bayangan
                          offset: Offset(
                              0, 3), // Offset bayangan (horizontal, vertical)
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: todoList[index].done
                          ? IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: Color(0xff5E6C2F),
                              ),
                              onPressed: () {
                                updateItem(index, !todoList[index].done);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.radio_button_unchecked),
                              onPressed: () {
                                updateItem(index, !todoList[index].done);
                              },
                            ),
                      title: Text(
                        todoList[index].nama,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xff5E6C2F),
                        ),
                      ),
                      subtitle: Text(
                        todoList[index].deskripsi,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff5E6C2F),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteItem(todoList[index].id ?? 0);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff5E6C2F),
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          tampilForm();
        },
      ),
    );
  }
}
