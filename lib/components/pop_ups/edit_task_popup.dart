import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/buttons/square_button.dart';
import 'package:morphe/components/menus/day_picker.dart';
import 'package:morphe/components/text_fields/add_property_field.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../model/task.dart';
import '../../model/user_data.dart';
import '../../utils/functions.dart';
import '../menus/frequency_picker.dart';
import '../menus/time_picker.dart';

class EditTaskPopUp extends StatefulWidget {
  Task task;

  EditTaskPopUp({required this.task, super.key});

  @override
  State<EditTaskPopUp> createState() => _EditTaskPopUpState();
}

class _EditTaskPopUpState extends State<EditTaskPopUp>
    with SingleTickerProviderStateMixin {
  late TextEditingController taskTitleController;
  late TextEditingController taskSubtitleController;
  late TextEditingController taskDescriptionController;

  late bool notifications;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late FrequencyPicker frequencyPicker;
  late DayPicker dayPicker;
  late TimePicker startTimePicker;
  late TimePicker endTimePicker;

  @override
  void initState() {
    super.initState();
    notifications = widget.task.notifications;

    frequencyPicker = FrequencyPicker(
      frequency: widget.task.scheduledFrequency,
    );
    dayPicker = DayPicker(day: widget.task.scheduledDay);
    startTimePicker = TimePicker(time: widget.task.startDateTime);
    endTimePicker = TimePicker(time: widget.task.endDateTime);

    taskTitleController = TextEditingController(text: widget.task.title);
    taskSubtitleController = TextEditingController(text: widget.task.subtitle);
    taskDescriptionController = TextEditingController(
      text: widget.task.description,
    );

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
                      "Edit task",
                      style: kTitleTextStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TaskPropertyField(
                    hint: "Task name*",
                    controller: taskTitleController,
                    onChanged: (newTasktitle) {
                      setState(() {
                        widget.task.title = newTasktitle;
                      });
                    },
                  ),
                  TaskPropertyField(
                    hint: "Task subtitle*",
                    controller: taskSubtitleController,
                    height: 100,
                    onChanged: (newTaskSubtitle) {
                      setState(() {
                        widget.task.subtitle = newTaskSubtitle;
                      });
                    },
                  ),
                  TaskPropertyField(
                    hint: "Type description here*",
                    controller: taskDescriptionController,
                    height: 150,
                    onChanged: (newTaskDescription) {
                      setState(() {
                        widget.task.description = newTaskDescription;
                      });
                    },
                  ),
                  Text(
                    "*Day is irrelevant if frequency is daily",
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
                  SizedBox(height: 20),
                  SquareButton(
                    color: widget.task.type.getColor(),
                    title: "Save changes",
                    onPressed: () {
                      print(
                        "${widget.task.title} ${widget.task.subtitle} ${widget.task.description} ${frequencyPicker.frequency} ${dayPicker.day} ${startTimePicker.newTime} ${endTimePicker.newTime} ${notifications}",
                      );
                      try {
                        user.updateTask(
                          widget.task.title,
                          widget.task.subtitle,
                          widget.task.description,
                          frequencyPicker.frequency,
                          dayPicker.day,
                          toDateTime(startTimePicker.newTime),
                          toDateTime(endTimePicker.newTime),
                          notifications,
                          widget.task.type,
                          widget.task.id,
                        );

                        Navigator.of(context).pop();
                      } catch (e) {
                        toastification.show(
                          context: context,
                          title: Text('Try again'),
                          description: Text('Something went wrong'),
                          type: ToastificationType.error,
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
