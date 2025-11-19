import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoViewModel {
  List<String> tasks = [];

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("tasks");
    if (data != null) {
      tasks = List<String>.from(jsonDecode(data));
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("tasks", jsonEncode(tasks));
  }

  void addTask(String task) {
    tasks.add(task);
    saveTasks();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    saveTasks();
  }

  void updateTask(int index, String newTask) {
    tasks[index] = newTask;
    saveTasks();
  }
}
