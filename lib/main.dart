import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> todoList = [];
  TextEditingController textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int editingIndex = -1;
  final player=AudioPlayer()..setReleaseMode(ReleaseMode.loop);

  @override
  Widget build(BuildContext context) {
    player.play(AssetSource('The Name Of Life - Spirited Away.mp3'));
    return Scaffold(
      appBar: AppBar(
        title: Text('備忘清單'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(labelText: '新增備忘事項'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(editingIndex == -1 ? Icons.add : Icons.save),
                      onPressed: () {
                        String newItem = textController.text;
                        if (newItem.isNotEmpty) {
                          setState(() {
                            if (editingIndex == -1) {
                              todoList.add(TodoItem(newItem, selectedDate));
                            } else {
                              todoList[editingIndex] = TodoItem(newItem, selectedDate);
                              editingIndex = -1;
                            }
                            textController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("截止日期: ${selectedDate.toLocal()}"),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList[index].task),
                  subtitle: Text("截止至: ${todoList[index].dueDate.toLocal()}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            editingIndex = index;
                            textController.text = todoList[index].task;
                            selectedDate = todoList[index].dueDate;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            todoList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class TodoItem {
  String task;
  DateTime dueDate;

  TodoItem(this.task, this.dueDate);
}
