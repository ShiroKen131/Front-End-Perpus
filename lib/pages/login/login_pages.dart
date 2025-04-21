import 'package:flutter/material.dart';
import '../register/register_pages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../book_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}






class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

Future<void> loginUser() async {
  final String email = _nameController.text;
  final String password = _passwordController.text;

  setState(() {
    _isLoading = true;
  });

  // Untuk sementara, gunakan simulasi login berhasil untuk testing navigasi
  bool useSimulatedLogin = true; // Set ke false jika API sudah tersedia

  if (useSimulatedLogin) {
    // Simulasi network delay
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
    
    // Simpan token dummy
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'dummy_token_for_testing');
    
    // Navigasi ke BookPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BookPage()),
    );
    
    return;
  }

  // Kode asli untuk menghubungi API
  try {
    print('Trying to connect to API...');
    const String apiUrl = 'http://127.0.0.1:8000/api/auth/login'; 
    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(Duration(seconds: 10)); // Tambahkan timeout

    setState(() {
      _isLoading = false;
    });

    print('STATUS: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Simpan token
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        
        // Navigasi ke BookPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login gagal')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${response.statusCode}')),
      );
    }
  } catch (e) {
    print('Login error: $e');
    setState(() {
      _isLoading = false;
    });
    
    // Tampilkan pesan error dan panduannya
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Koneksi Gagal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tidak dapat terhubung ke server API: $e'),
            SizedBox(height: 10),
            Text('Pastikan:'),
            Text('1. Server API berjalan di http://127.0.0.1:8000'),
            Text('2. Tidak ada masalah jaringan'),
            Text('3. CORS diaktifkan jika menjalankan di web'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Gunakan simulasi login untuk testing UI
              loginWithSimulation();
            },
            child: Text('Gunakan Mode Simulasi'),
          ),
        ],
      ),
    );
  }
}

// Fungsi tambahan untuk simulasi login
Future<void> loginWithSimulation() async {
  setState(() {
    _isLoading = true;
  });
  
  // Simulasi delay jaringan
  await Future.delayed(Duration(seconds: 1));
  
  setState(() {
    _isLoading = false;
  });
  
  // Simpan token dummy
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', 'dummy_token_for_testing');
  
  // Navigasi ke BookPage
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => BookPage()),
  );
}

@override
void initState() {
  super.initState();
  // Cek apakah sudah login
  checkLoginStatus();
}

Future<void> checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  
  if (token != null) {
    // Jika sudah ada token, langsung navigasi ke BookPage
    print('Token found, navigating to BookPage');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BookPage()),
    );
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width to make container responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.85; // Use 85% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD6E5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login Perpustakaan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Book logo
                  Image.asset(
                    'assets/book_logo.png', // Replace with your actual book logo path
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.menu_book, // Book icon as fallback
                        size: 120,
                        color: Color(0xFFFF9CC4),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Username',
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFFFF9CC4)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFFFF9CC4)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                loginUser();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9CC4),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            color: Color(0xFFFF9CC4),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
