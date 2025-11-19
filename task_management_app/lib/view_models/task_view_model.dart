import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/shared_preferences_service.dart';

class TaskViewModel with ChangeNotifier {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  TaskViewModel() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasksData = await _prefsService.loadTasks();
    _tasks = tasksData.map((data) => Task.fromJson(data)).toList();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final tasksData = _tasks.map((task) => task.toJson()).toList();
    await _prefsService.saveTasks(tasksData);
  }

  Future<void> addTask(String title, String description) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    _tasks.insert(0, newTask);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        isCompleted: !_tasks[taskIndex].isCompleted,
      );
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> updateTask(
    String taskId,
    String title,
    String description,
  ) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        title: title,
        description: description,
      );
      await _saveTasks();
      notifyListeners();
    }
  }
}
