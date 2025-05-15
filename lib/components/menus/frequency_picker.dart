import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../../utils/enums.dart';

class FrequencyPicker extends StatefulWidget {
  late Frequency frequency;

  FrequencyPicker({this.frequency = Frequency.DAILY, super.key});

  @override
  State<FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
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
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Theme.of(context).cardColor,
        child: MenuAnchor(
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return GestureDetector(
              onTap: () {
                controller.open();
              },
              child: ListTile(
                contentPadding: EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                  bottom: 10.0,
                ),
                leading: Text(
                  widget.frequency.format(),
                  style: kInputPlaceHolderText.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
          menuChildren: List<MenuItemButton>.generate(
            Frequency.values.length,
            (int index) => MenuItemButton(
              onPressed: () {
                setState(() {
                  widget.frequency = Frequency.values[index];
                });
              },
              child: Text(
                Frequency.values[index].format(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
