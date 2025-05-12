import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../../utils/functions.dart';

class TimePicker extends StatefulWidget {
  final DateTime time;
  late TimeOfDay newTime;

  TimePicker({required this.time, super.key}) {
    newTime = TimeOfDay.fromDateTime(time);
  }

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.newTime,
    );

    if (picked != null && picked != widget.newTime) {
      setState(() {
        widget.newTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card.outlined(
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 3.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Theme.of(context).cardColor,
        child: GestureDetector(
          onTap: () {
            _selectTime(context);
          },
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
              bottom: 10.0,
            ),
            leading: Text(
              widget.newTime.format(context),
              style: kInputPlaceHolderText.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            trailing: Icon(Icons.timer, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
