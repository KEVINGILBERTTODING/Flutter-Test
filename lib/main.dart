import 'package:fluttapp/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: MyCustomForm()),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  TextEditingController usrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'logo.png',
                  height: 300,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai, Selamat Datang',
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                    Text(
                      'Kelola tugas Anda hari ini untuk meningkatkan produktivitas Anda!',
                      style: TextStyle(fontSize: 15, fontFamily: 'Popmed'),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: usrController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 205, 37, 234),
                    foregroundColor: Colors.white),
                onPressed: () {
                  String username = usrController.text;

                  if (username.isEmpty) {
                    showSnackBar("Username tidak boleh kosong");

                    return;
                  }
                  navigatorScreen(context, const Home(), username);
                },
                child: const Text('Mulai Sekarang'),
              ),
            )
          ],
        ),
      ],
    );
  }

  void navigatorScreen(BuildContext context, Widget screen, String username) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    saveUserInfo(username);
  }

  void saveUserInfo(String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", username);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 20),
    ));
  }
}
