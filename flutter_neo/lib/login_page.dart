import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_neo/main.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'sign_up.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String> _getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/infos.json';
  }

  Future<void> _load() async {
    String filePath = await _getFilePath();
    File file = File(filePath);

    if (await file.exists()) {
      String fileContent = await file.readAsString();
      if (fileContent.isNotEmpty) {
        try {
          List<dynamic> users = jsonDecode(fileContent);

          bool isValidUser = users.any((user) =>
              user['username'] == _usernameController.text.trim() &&
              user['password'] == _passwordController.text.trim());

          if (isValidUser) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TodoListScreen()),
            );
          } else {
            _showError("Geçersiz kullanıcı adı veya şifre.");
          }
        } catch (e) {
          _showError("Veri okunurken hata oluştu.");
        }
      } else {
        _showError("Kullanıcı bilgileri bulunamadı.");
      }
    } else {
      _showError("Kayıtlı kullanıcı yok.");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş'),
        backgroundColor: Color.fromARGB(255, 147, 33, 208),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _load, // _login yerine direkt _load çağrılıyor
              child: Text('Giriş'),
            ),
            SizedBox(height: 20),
            Text('Hesabın yok mu?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 230, 230, 250),
    );
  }
}
