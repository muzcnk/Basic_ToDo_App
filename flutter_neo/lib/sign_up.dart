import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String> _getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/infos.json';
  }

  Future<void> _save() async {
    String filePath = await _getFilePath();
    File file = File(filePath);

    List<dynamic> users = [];

    if (await file.exists()) {
      String fileContent = await file.readAsString();
      if (fileContent.isNotEmpty) {
        try {
          users = jsonDecode(fileContent);
        } catch (e) {
          users = [];
        }
      }
    }

    Map<String, String> newUser = {
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    if (newUser['username']!.isEmpty || newUser['password']!.isEmpty) {
      _showError("Kullanıcı adı ve şifre boş olamaz.");
      return;
    }

    bool userExists =
        users.any((user) => user['username'] == newUser['username']);
    if (userExists) {
      _showError("Bu kullanıcı adı zaten kullanılıyor.");
      return;
    }

    users.add(newUser);
    await file.writeAsString(jsonEncode(users));

    _showSuccess();
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccess() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Başarılı'),
          content: Text('Kayıt başarılı! Şimdi giriş yapabilirsiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
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
        title: Text('Kayıt Ol'),
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
              onPressed: _save,
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
