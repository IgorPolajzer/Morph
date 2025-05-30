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
  var tasks = <Task>[];
  var habits = <Habit>[];

  for (HabitType type in HabitType.values) {
    if (selectedHabits[type] == true) {
      var userPrompt =
          "Category: ${type.name.toLowerCase()}\nUser Input: ${prompts[type]}";
      final body = getBody(kMetaSystemPrompt, userPrompt);
      dynamic planJson;

      //Make API call
      while (planJson == null) {
        try {
          final response = await http.post(uri, headers: headers, body: body);
          planJson = jsonDecode(
            jsonDecode(response.body)['choices'][0]['text'],
          );
        } catch (e) {
          print(e);
        }
      }

      if (planJson['valid'] == false || planJson['error'] != null) {
        throw GenerationException(planJson['error']);
      }

      tasks.addAll(parseTasks(planJson["tasks"]));
      habits.addAll(parseHabits(planJson["habits"]));
    }
  }

  return Pair<List<Task>, List<Habit>>(tasks, habits);
}

String getBody(String systemPrompt, String userPrompt) {
  return jsonEncode({
    "model": "Meta-Llama-3.1-70B-Instruct",
    "prompt":
        "<|begin_of_text|><|start_header_id|>system<|end_header_id|>${systemPrompt}<|eot_id|><|start_header_id|>user<|end_header_id|>$userPrompt<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n",
    "temperature": 0.2,
    "top_p": 0.9,
    "top_k": 40,
    "repetition_penalty": 1.1,
    "max_tokens": 1024,
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
