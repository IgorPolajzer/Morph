import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/buttons/square_button.dart';
import 'package:morphe/components/menus/day_picker.dart';
import 'package:morphe/components/text_fields/add_property_field.dart';
import 'package:morphe/repositories/impl/task_repository.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:morphe/services/notification_service.dart';
import '../../model/task.dart';
import '../../state/user_data.dart';
import '../../utils/functions.dart';
import '../../utils/toast_util.dart';
import '../menus/frequency_picker.dart';
import '../menus/time_picker.dart';

class EditTaskPopUp extends StatefulWidget {
  final Task task;

  const EditTaskPopUp({required this.task, super.key});

  @override
  State<EditTaskPopUp> createState() => _EditTaskPopUpState();
}

class _EditTaskPopUpState extends State<EditTaskPopUp>
    with SingleTickerProviderStateMixin {
  // Repositories.
  final taskRepository = TaskRepository();

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

  // Task attributes.
  late String title;
  late String subtitle;
  late String description;

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

    title = widget.task.title;
    subtitle = widget.task.subtitle;
    description = widget.task.description;

    taskTitleController = TextEditingController(text: title);
    taskSubtitleController = TextEditingController(text: subtitle);
    taskDescriptionController = TextEditingController(text: description);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: PopupCard(
        elevation: 8,
        shape: const RoundedRectangleBorder(
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            bottom: 5.0,
                          ),
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
                              title = newTasktitle;
                            });
                          },
                        ),
                        TaskPropertyField(
                          hint: "Task subtitle*",
                          controller: taskSubtitleController,
                          height: 100,
                          onChanged: (newTaskSubtitle) {
                            setState(() {
                              subtitle = newTaskSubtitle;
                            });
                          },
                        ),
                        TaskPropertyField(
                          hint: "Type description here*",
                          controller: taskDescriptionController,
                          height: 150,
                          onChanged: (newTaskDescription) {
                            setState(() {
                              description = newTaskDescription;
                            });
                          },
                        ),
                        const Text(
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
                      ],
                    ),
                  ),
                ),
                SquareButton(
                  color: widget.task.type.getColor(),
                  title: "Save changes",
                  onPressed: () async {
                    try {
                      final userData = context.read<UserData>();
                      final notificationService = NotificationService();

                      // Cancel the old notification before updating the task
                      await notificationService.cancelTaskNotification(widget.task);

                      var updatedTask = userData.updateTask(
                        title,
                        subtitle,
                        description,
                        frequencyPicker.frequency,
                        dayPicker.day,
                        toDateTime(startTimePicker.newTime),
                        toDateTime(endTimePicker.newTime),
                        notifications,
                        widget.task.type,
                        widget.task.id,
                      );

                      if (updatedTask != null) {
                        // Schedule a new notification for the updated task
                        await notificationService.scheduleTaskNotification(updatedTask);
                        await taskRepository.update(
                          userData.userId,
                          widget.task.id,
                          updatedTask.toMap(),
                        );
                      }

                      Navigator.of(context).pop();
                    } catch (e) {
                      somethingWentWrongToast(context);
                    }
                  },
                ),
              ],
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
