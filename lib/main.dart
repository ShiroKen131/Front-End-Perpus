import 'package:flutter/material.dart';
import 'package:bukuxirplb/pages/login/login_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Buku',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginPage(),
    );
  }
}