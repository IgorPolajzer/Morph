import 'package:flutter/material.dart';
import 'package:morphe/components/edit_property_field.dart';
import 'package:morphe/utils/constants.dart';

import '../components/screen_title.dart';
import '../utils/enums.dart';

class EditTaskScreenArguments {
  late String title;
  late String subtitle;
  late String description;
  late DateTime startDateTime;
  late DateTime endDateTime;
  late HabitType type;
  late Widget customWidget;

  EditTaskScreenArguments({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
  });
}

class EditTaskScreen extends StatefulWidget {
  static String id = '/edit_task_screen';

  EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditTaskScreenArguments;
    String selectedDay = "Monday";
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTitle(title: "Edit task"),
          EditPropertyField(title: "Title: ", value: args.title),
          EditPropertyField(title: "Subtitle: ", value: args.subtitle),
          EditPropertyField(title: "Description: ", value: args.description),
          DropdownButton<String>(
            value: selectedDay,
            onChanged: (String? newValue) {
              setState(() {
                selectedDay = newValue!;
              });
            },
            items:
                <String>[
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
