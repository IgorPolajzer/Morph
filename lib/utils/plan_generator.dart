import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:morphe/exceptions/generation_exception.dart';
import 'package:morphe/exceptions/request_exception.dart';

import '../model/habit.dart';
import '../model/task.dart';
import 'constants.dart';
import 'enums.dart';
import 'package:pair/pair.dart';

// Firebase AI Logic SDK Configuration
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  systemInstruction: Content.system(kSystemPrompt),
  generationConfig: GenerationConfig(maxOutputTokens: kMaxOutputTokens),
);

Future<Pair<List<Task>, List<Habit>>> generateAndParse(
  Map<HabitType, String> prompts,
  Map<HabitType, bool> selectedHabits,
) async {
  final tasks = <Task>[];
  final habits = <Habit>[];

  String userPrompt = "";

  // Structure user prompt.
  for (HabitType type in HabitType.values) {
    if (selectedHabits[type] == true) {
      userPrompt +=
          "Category: ${type.name.toLowerCase()}\nUser Input: ${prompts[type]}\n";
    }
  }

  dynamic planJson;

  int attempts = 0;
  const int maxAttempts = 3;

  while (planJson == null && attempts < maxAttempts) {
    attempts++;
    try {
      // Check token count.
      var tokenCount = await model.countTokens([Content.text(userPrompt)]);

      if (tokenCount.totalTokens <= kMaxInputTokens) {
        // Generate plans.
        var response = await model.generateContent([Content.text(userPrompt)]);
        var rawOutput =
            (response.candidates.first.content.parts.first as TextPart).text;

        var jsonString = cleanModelOutput(rawOutput);
        planJson = jsonDecode(jsonString);
      } else {
        throw RequestException("User prompt exceeds set max token count.");
      }
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

// TODO unit tests
String cleanModelOutput(String raw) {
  var cleaned = raw.trim();
  if (cleaned.startsWith("```json")) {
    cleaned = cleaned.substring(7).trim(); // remove ```json
  } else if (cleaned.startsWith("```")) {
    cleaned = cleaned.substring(3).trim(); // remove ```
  }
  if (cleaned.endsWith("```")) {
    cleaned = cleaned.substring(0, cleaned.length - 3).trim();
  }
  return cleaned;
}

// TODO unit tests
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

// TODO unit tests
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
