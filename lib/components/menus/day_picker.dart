import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../../utils/enums.dart';

class DayPicker extends StatefulWidget {
  late Days day;

  DayPicker({this.day = Days.MONDAY, super.key});

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // adjust as neede
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
                  widget.day.name.toLowerCase(),
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
            Days.values.length,
            (int index) => MenuItemButton(
              onPressed: () {
                setState(() {
                  widget.day = Days.values[index];
                });
              },
              child: Text(
                Days.values[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
