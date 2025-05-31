import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morphe/model/generation_exception.dart';

import '../model/habit.dart';
import '../model/task.dart';
import 'constants.dart';
import 'enums.dart';
import 'package:pair/pair.dart';

/// API configuration
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${dotenv.env['AWAN_LLM_API_KEY']}',
};
final uri = Uri.parse('https://api.awanllm.com/v1/completions');

Future<Pair<List<Task>, List<Habit>>> generateAndParse(
  Map<HabitType, String> prompts,
  Map<HabitType, bool> selectedHabits,
) async {
  final tasks = <Task>[];
  final habits = <Habit>[];

  String userPrompt = "";

  for (HabitType type in HabitType.values) {
    if (selectedHabits[type] == true) {
      userPrompt +=
          "Category: ${type.name.toLowerCase()}\nUser Input: ${prompts[type]}\n";
    }
  }

  final body = getBody(kMetaSystemPrompt, userPrompt);
  dynamic planJson;

  int attempts = 0;
  const int maxAttempts = 3;

  while (planJson == null && attempts < maxAttempts) {
    attempts++;
    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode != 200) {
        throw GenerationException(
          'API returned status ${response.statusCode}: ${response.body}',
        );
      }
      planJson = jsonDecode(jsonDecode(response.body)['choices'][0]['text']);
    } catch (e) {
      print('Attempt $attempts failed: $e');
      await Future.delayed(Duration(seconds: 2));
    }
  }

  if (planJson == null) {
    throw GenerationException(
      "Failed to get valid response from API after $maxAttempts attempts",
    );
  }

  if (planJson['valid'] == false || planJson['error'] != null) {
    throw GenerationException(planJson['error']);
  }

  tasks.addAll(parseTasks(planJson["tasks"]));
  habits.addAll(parseHabits(planJson["habits"]));

  return Pair<List<Task>, List<Habit>>(tasks, habits);
}

/*Future<void> _generateAndParseSingleCategory(
  HabitType type,
  String prompt,
  List<Task> tasks,
  List<Habit> habits,
) async {
  var userPrompt = "Category: ${type.name.toLowerCase()}\nUser Input: $prompt";
  final body = getBody(kMetaSystemPrompt, userPrompt);
  dynamic planJson;

  int attempts = 0;
  const int maxAttempts = 3;

  while (planJson == null && attempts < maxAttempts) {
    attempts++;
    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode != 200) {
        throw GenerationException(
          'API returned status ${response.statusCode}: ${response.body}',
        );
      }
      planJson = jsonDecode(jsonDecode(response.body)['choices'][0]['text']);
    } catch (e) {
      print('Attempt $attempts failed: $e');
      await Future.delayed(Duration(seconds: 2));
    }
  }

  if (planJson == null) {
    throw GenerationException(
      "Failed to get valid response from API after $maxAttempts attempts",
    );
  }

  if (planJson['valid'] == false || planJson['error'] != null) {
    throw GenerationException(planJson['error']);
  }

  tasks.addAll(parseTasks(planJson["tasks"]));
  habits.addAll(parseHabits(planJson["habits"]));
}*/

String getBody(String systemPrompt, String userPrompt) {
  String model = "Meta-Llama-3.1-70B-Instruct";
  return jsonEncode({
    "model": model,
    "prompt":
        "<|begin_of_text|><|start_header_id|>system<|end_header_id|>${systemPrompt}<|eot_id|><|start_header_id|>user<|end_header_id|>$userPrompt<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n",
    "temperature": 0.2,
    "top_p": 0.7,
    "top_k": 20,
    "repetition_penalty": 1.1,
    "max_tokens": 1500,
    "stream": false,
  });
}

List<Task> parseTasks(List<dynamic> list) {
  final tasks = <Task>[];

  for (var taskMap in list) {
    if (taskMap is Map<String, dynamic>) {
      try {
        tasks.add(
          Task(
            title: taskMap['title'] ?? '',
            subtitle: taskMap['subtitle'] ?? '',
            description: taskMap['description'] ?? '',
            scheduledFrequency: Frequency.getFrequencyFromString(
              taskMap['scheduledFrequency'] ?? '',
            ),
            scheduledDay: Day.getDayFromString(taskMap['scheduledDay'] ?? ''),
            startDateTime: DateTime.parse(taskMap['startDateTime']),
            endDateTime: DateTime.parse(taskMap['endDateTime']),
            type: HabitType.getTypeFromString(taskMap['type'] ?? ''),
            notifications: taskMap['notifications'] ?? false,
          ),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  return tasks;
}

List<Habit> parseHabits(List<dynamic> list) {
  final habits = <Habit>[];

  for (var habitMap in list) {
    if (habitMap is Map<String, dynamic>) {
      try {
        habits.add(
          Habit(
            title: habitMap['title'] ?? '',
            description: habitMap['description'] ?? '',
            type: HabitType.getTypeFromString(habitMap['type'] ?? ''),
            notifications: habitMap['notifications'] ?? false,
          ),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  return habits;
}
