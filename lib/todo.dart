class Todo {
  int? id;
  String nama;
  String deskripsi;
  bool done;

  Todo(this.nama, this.deskripsi, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("Makan siang", "Makan siang setelah habis kelas"),
    Todo("Pulang", "Pulang dari kampus karena keapekan", done: true),
    Todo("Tidur", "Mengantuk saat melihat tutorial"),
  ];

  // penyimpanan Sqlite menggunakan map,
  // maka dibuat fungsi untuk menyimpan data yang dari Objek dirubah ke Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'done': done,
    };
  }

  // Factory untuk memudahkan flutter merubah Map menjadi Objek Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      map['nama'] as String,
      map['deskripsi'] as String,
      done: map['done'] == 0 ? false : true,
      id: map['id'],
    );
  }
}
