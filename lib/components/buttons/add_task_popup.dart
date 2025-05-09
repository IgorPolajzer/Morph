import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/menus/day_picker.dart';
import 'package:morphe/components/text_fields/add_property_field.dart';
import 'package:morphe/utils/constants.dart';

import '../menus/frequency_picker.dart';
import '../menus/time_picker.dart';

class AddTaskPopUp extends StatelessWidget {
  const AddTaskPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupCard(
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
              TaskPropertyField(hint: "Task name*"),
              TaskPropertyField(hint: "Type description here*", height: 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: FrequencyPicker()),
                    Expanded(child: DayPicker()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: TimePicker(time: DateTime.now())),
                    Expanded(child: TimePicker(time: DateTime.now())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
