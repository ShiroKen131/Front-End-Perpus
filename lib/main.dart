import 'package:flutter/material.dart';
import 'package:bukuxirplb/pages/login/login_pages.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bukuxirplb/pages/book_page.dart';
import 'package:bukuxirplb/pages/register/register_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan Digital',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9CC4),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9CC4)),
        useMaterial3: true,
      ),
      home: const AuthChecker(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const BookPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
    print('BookPage dimuat!');
  }

  Future<void> _checkIfLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    
    setState(() {
      _isLoggedIn = token != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF9CC4)),
        ),
      );
    } else {
      if (_isLoggedIn) {
        return const BookPage();
      } else {
        return const LoginPage();
      }
    }
  }
}