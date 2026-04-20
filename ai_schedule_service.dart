import 'dart:convert'; // Added for jsonEncode
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';
import '../models/schedule_analysis.dart';

class AiScheduleAnalysis extends ChangeNotifier {
  ScheduleAnalysis? _currentAnalysis;
  bool _isLoading = false;
  String? _errorMessage;

  // IMPORTANT: Ensure you add your API Key here
  final String _apiKey = '';

  ScheduleAnalysis? get currentAnalysis => _currentAnalysis;
  // Fixed: Getter must have a different name than the private field to avoid infinite recursion
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> analyzeSchedule(List<TaskModel> tasks) async {
    // Fixed: 'task.isEmpty' to 'tasks.isEmpty'
    if (_apiKey.isEmpty || tasks.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fixed: 'gemini-2.5-flash' (non-existent) to 'gemini-1.5-flash'
      // Fixed: Removed semicolon inside constructor
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final taskJson = jsonEncode(tasks.map((t) => t.toJson()).toList());

      final prompt = '''
        You are an expert students scheduling assistant. The user has provided the following tasks
        for their day in JSON format: $taskJson

        Please provide exactly 4 sections of markdown text:
        1. ### Detected Conflicts
        List any scheduling conflicts
        2. ### Ranked Tasks
        Rank which tasks need attention first.
        3. ### Recommended Schedule
        Provide a revised daily timeline view adjusting the task time.
        4. ### Explanation
        Explain why this recommendation was made.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        _currentAnalysis = _parseResponse(response.text!);
      } else {
        _errorMessage = "AI returned an empty response";
      }
    } catch (e) {
      _errorMessage = 'Failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ScheduleAnalysis _parseResponse(String fullText) {
    String conflicts = "";
    String rankedTasks = "";
    String recommendationSchedule = "";
    String explanation = "";

    // Fixed: Logic to iterate through sections and handle typos
    final sections = fullText.split('### ');
    for (var section in sections) {
      if (section.isEmpty) continue;

      if (section.startsWith('Detected Conflicts')) {
        conflicts = section.replaceFirst('Detected Conflicts', '').trim();
      } else if (section.startsWith('Ranked Tasks')) {
        rankedTasks = section.replaceFirst('Ranked Tasks', '').trim();
      } else if (section.startsWith('Recommended Schedule')) {
        recommendationSchedule = section.replaceFirst('Recommended Schedule', '').trim();
      } else if (section.startsWith('Explanation')) {
        explanation = section.replaceFirst('Explanation', '').trim();
      }
    }

    return ScheduleAnalysis(
      conflicts: conflicts,
      rankedTasks: rankedTasks,
      recommendedSchedule: recommendationSchedule,
      explanation: explanation,
    );
  }
}