import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

TextEditingController usrController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: MyCustomForm()),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Login'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: usrController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
        ),
        // ignore: sized_box_for_whitespace
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.amber, foregroundColor: Colors.white),
            onPressed: () {
              String username = usrController.text;
              String password = passwordController.text;

              if (username.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Username kosong'),
                  duration: Duration(seconds: 2),
                ));
                return;
              }

              if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Kata sandi kosong'),
                  duration: Duration(seconds: 2),
                ));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('username: $username, password: $password'),
                duration: Duration(seconds: 2),
              ));
            },
            child: const Text('Masuk'),
          ),
        )
      ],
    );
  }
}
