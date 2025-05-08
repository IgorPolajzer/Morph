import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../utils/enums.dart';

class DescribeGoalInputBox extends StatelessWidget {
  final HabitType type;
  final String title;
  final String description;
  final String hint;
  final bool enabled;

  const DescribeGoalInputBox({
    required this.type,
    required this.title,
    required this.description,
    required this.hint,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var disabledColor =
        Theme.of(context).extension<CustomColors>()!.placeholderTextColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 43.0, right: 43.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color:
                    enabled
                        ? type.getColor()
                        : Theme.of(
                          context,
                        ).extension<CustomColors>()!.placeholderTextColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: 8,
                  right: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: kGoalTitleTextStyle.copyWith(
                        color:
                            Theme.of(
                              context,
                            ).extension<CustomColors>()!.headerColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.question_mark_sharp,
                      color:
                          Theme.of(
                            context,
                          ).extension<CustomColors>()!.headerColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 175,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(17),
                    bottomLeft: Radius.circular(17),
                    bottomRight: Radius.circular(17),
                  ),
                  color: enabled ? type.getColor() : disabledColor,
                ),
                child: TextField(
                  enabled: enabled,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top, // Align text to top
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ), // Top padding to push text down a bit
                    hintText: description,
                    hintStyle: kPlaceHolderTextStyle.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).extension<CustomColors>()!.placeholderTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: type.getColor(),
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: type.getColor(),
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: disabledColor, width: 4.0),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: type.getColor(),
                        width: 6.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
