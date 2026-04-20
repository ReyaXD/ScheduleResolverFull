import 'package:flutter/material.dart';
import '../models/task_model.dart'; // Fixed: Typo in filename (removed 's')
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  final Uuid _uuid = const Uuid();

  List<TaskModel> get tasks => _tasks;

  void addTask({
    required String title,
    required String category,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int urgency,
    required int importance,
    required double estimatedEffortHours,
    required String energyLevel,
  }) {
    final newTask = TaskModel(
      id: _uuid.v4(), // Fixed: 'id' was undefined; now generates a new UUID
      title: title,
      category: category,
      date: date,
      startTime: startTime,
      endTime: endTime,
      urgency: urgency,
      importance: importance,
      estimatedEffortHours: estimatedEffortHours,
      energyLevel: energyLevel,
    );
    _tasks.add(newTask); // Fixed: was adding a String 'newTask' instead of the object
    notifyListeners();
  }

  void removeTask(String id) {
    // Fixed: typo '_task' changed to '_tasks' to match the variable name
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}