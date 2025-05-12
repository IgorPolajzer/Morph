import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../../utils/enums.dart';

class TaskPropertyField extends StatelessWidget {
  final String hint;
  final double height;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const TaskPropertyField({
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.height = 65,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late OutlineInputBorder enabledOutlineInputBorder;
    late OutlineInputBorder focusedOutlineInputBorder;

    enabledOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).secondaryHeaderColor,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    focusedOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        child: Container(
          child: TextField(
            controller: controller,
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            style: kInputPlaceHolderText.copyWith(
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.start,
            onChanged: onChanged,
            decoration: kTextFieldDecoration.copyWith(
              hintText: hint,
              hintStyle: kInputPlaceHolderText.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              enabledBorder: enabledOutlineInputBorder,
              focusedBorder: focusedOutlineInputBorder,
            ),
          ),
        ),
      ),
    );
  }
}
