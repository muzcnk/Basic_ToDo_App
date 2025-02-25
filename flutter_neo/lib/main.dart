import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_neo/login_page.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todoList = [];

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add(task);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Geçersiz Görev'),
            content: Text('Boş Görev Girilemez'),
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
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  void _editTodoItem(int index) {
    TextEditingController _editController = TextEditingController();
    _editController.text = _todoList[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Görevi Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lütfen görevinizi düzeltiniz'),
              TextField(
                controller: _editController,
                decoration: InputDecoration(labelText: 'Görevi Düzenle'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Yoksay'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todoList[index] = _editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Kaydet'),
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
        automaticallyImplyLeading: false,
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Exit'),
                  content:
                      Text('Uygulamadan çıkmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
                    ),
                    Container(
                      width: double.infinity,
                      height: 2.0,
                      color: Colors.grey,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Evet'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTodoList(),
          _buildAddTodoTextField(),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_todoList[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeTodoItem(index),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editTodoItem(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddTodoTextField() {
    final TextEditingController _textController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Görev Ekle',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addTodoItem(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
