// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:prg3/screens/home.dart';
import 'package:prg3/screens/login.dart';

void main() {
  runApp(const MainApp());
}

//MAIN
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users CRUD',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
      },
    );
  }
}
