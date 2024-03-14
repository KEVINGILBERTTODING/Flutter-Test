// ignore_for_file: use_build_context_synchronously

import 'package:fluttapp/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: _HomeState()),
    );
  }
}

class _HomeState extends StatefulWidget {
  @override
  __HomeStateState createState() => __HomeStateState();
}

class __HomeStateState extends State<_HomeState> {
  late TextEditingController newTaskController;

  @override
  void initState() {
    super.initState();
    newTaskController =
        TextEditingController(); // Inisialisasi newTaskController
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: loadUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          String? username = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai, $username',
                      style: const TextStyle(
                          fontFamily: 'PoppinsMed', fontSize: 10),
                    ),
                    const Text(
                      'Ada tugas apa hari ini?',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                        child: FutureBuilder<List<Task>>(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error'),
                          );
                        } else {
                          List<Task> tasks = snapshot.data!;
                          return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              Task task = tasks[index];
                              return GestureDetector(
                                onTap: () {
                                  print('daa');
                                },
                                child: Card(
                                  color:
                                      const Color.fromARGB(255, 205, 37, 234),
                                  child: ListTile(
                                    title: Text(
                                      task.task,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      task.date,
                                      style: TextStyle(
                                          fontFamily: 'PoppinsMed',
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ))
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: const Text(
                              'Masukkan tugas baru anda',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 18),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: newTaskController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan tugas baru',
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 205, 37, 234),
                                    foregroundColor: Colors.white),
                                onPressed: () async {
                                  // Tambahkan aksi yang sesuai di sini, seperti menyimpan data atau menutup bottom sheet
                                  if (newTaskController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Task tidak boleh kosong'),
                                      duration: Duration(seconds: 10),
                                    ));
                                    return;
                                  } else {
                                    DateTime date = DateTime.now();
                                    int year = date.year;
                                    int month = date.month;
                                    int day = date.day;
                                    String dateTime = '$year-$month-$day';
                                    Task task = Task(
                                        task: newTaskController.text,
                                        date: dateTime);

                                    await insertData(task);
                                    setState(() {});

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Berhasil menambahkan tugas'),
                                      duration: Duration(seconds: 5),
                                    ));
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Simpan Tugas'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 205, 37, 234),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // Pastikan untuk membersihkan sumber daya yang digunakan oleh controller ketika widget dihapus
    newTaskController.dispose();
    super.dispose();
  }

  Future<String?> loadUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('username');
  }

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todolist.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertData(Task data) async {
    final db = await database();
    await db.insert(
      'task',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getData() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query('task');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        task: maps[i]['task'],
        date: maps[i]['date'],
      );
    });
  }
}
