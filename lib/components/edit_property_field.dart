import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../utils/enums.dart';

class EditPropertyField extends StatelessWidget {
  final String title;
  final String value;

  const EditPropertyField({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController titlecontroller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            title,
            style: kTitleTextStyle.copyWith(
              color: Theme.of(context).extension<CustomColors>()!.headerColor,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: titlecontroller,
              style: TextStyle(
                inherit: false,
                color: Theme.of(context).extension<CustomColors>()!.headerColor,
                fontSize: 24,
                fontWeight: FontWeight.w300,
                textBaseline: TextBaseline.ideographic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
