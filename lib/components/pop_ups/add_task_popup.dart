import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/buttons/square_button.dart';
import 'package:morphe/components/menus/day_picker.dart';
import 'package:morphe/components/text_fields/add_property_field.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../model/task.dart';
import '../../model/user_data.dart';
import '../../utils/functions.dart';
import '../menus/frequency_picker.dart';
import '../menus/time_picker.dart';

class AddTaskPopUp extends StatefulWidget {
  final HabitType type;

  const AddTaskPopUp({required this.type, super.key});

  @override
  State<AddTaskPopUp> createState() => _AddTaskPopUpState();
}

class _AddTaskPopUpState extends State<AddTaskPopUp>
    with SingleTickerProviderStateMixin {
  late TextEditingController taskTitleController;
  late TextEditingController taskSubtitleController;
  late TextEditingController taskDescriptionController;

  late String taskTitle;
  late String taskSubtitle;
  late String taskDescription;
  late Frequency taskScheduledFrequency;
  late Day taskScheduledDay;
  late DateTime taskStartDateTime;
  late DateTime taskEndDateTime;

  bool notifications = true;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late FrequencyPicker frequencyPicker;
  late DayPicker dayPicker;
  late TimePicker startTimePicker;
  late TimePicker endTimePicker;

  @override
  void initState() {
    super.initState();
    frequencyPicker = FrequencyPicker();
    dayPicker = DayPicker();
    startTimePicker = TimePicker(time: DateTime.now());
    endTimePicker = TimePicker(time: DateTime.now());

    taskTitleController = TextEditingController(text: "");
    taskSubtitleController = TextEditingController(text: "");
    taskDescriptionController = TextEditingController(text: "");

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: true);

    return SlideTransition(
      position: _offsetAnimation,
      child: PopupCard(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Card(
          color: Theme.of(context).cardColor,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 50,
            height: MediaQuery.sizeOf(context).height - 200,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                    child: Text(
                      "Add new task",
                      style: kTitleTextStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TaskPropertyField(
                    hint: "Task name*",
                    controller: taskTitleController,
                    onChanged: (newTaskName) {
                      setState(() {
                        taskTitle = newTaskName;
                      });
                    },
                  ),
                  TaskPropertyField(
                    hint: "Task subtitle*",
                    controller: taskSubtitleController,
                    height: 100,
                    onChanged: (newTaskSubtitle) {
                      setState(() {
                        taskSubtitle = newTaskSubtitle;
                      });
                    },
                  ),
                  TaskPropertyField(
                    hint: "Type description here*",
                    controller: taskDescriptionController,
                    height: 150,
                    onChanged: (newTaskDescription) {
                      setState(() {
                        taskDescription = newTaskDescription;
                      });
                    },
                  ),
                  Text(
                    "*Day is irrelevant if frequency is daily or monthly",
                    style: kPlaceHolderTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: frequencyPicker),
                        Expanded(child: dayPicker),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: startTimePicker),
                        Expanded(child: endTimePicker),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "Reminds me",
                      style: kTitleTextStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      value: notifications,
                      onChanged: (bool value) {
                        setState(() {
                          notifications = value;
                        });
                      },
                      activeTrackColor: CupertinoColors.activeGreen,
                    ),
                  ),
                  SquareButton(
                    color: widget.type.getColor(),
                    title: "Add Task",
                    onPressed: () {
                      try {
                        Task newTask = Task(
                          title: taskTitle,
                          subtitle: taskSubtitle,
                          description: taskDescription,
                          scheduledFrequency: frequencyPicker.frequency,
                          scheduledDay: dayPicker.day,
                          startDateTime: toDateTime(startTimePicker.newTime),
                          endDateTime: toDateTime(endTimePicker.newTime),
                          notifications: notifications,
                          type: widget.type,
                        );

                        user.addTask(newTask);

                        Navigator.of(context).pop();
                      } catch (e) {
                        toastification.show(
                          context: context,
                          title: Text('Try again'),
                          description: Text(
                            'Something went wrong while creating a task, make sure no field is empty',
                          ),
                          type: ToastificationType.info,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
