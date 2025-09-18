import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/utils/constants.dart';

import '../../utils/enums.dart';
import '../pop_ups/show_more_popup.dart';

class DescribeGoalField extends StatelessWidget {
  final HabitType type;
  final String title;
  final String description;
  final String hint;
  final bool enabled;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int maxCharacters;

  const DescribeGoalField({
    required this.type,
    required this.title,
    required this.description,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.maxCharacters,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var disabledColor = Theme.of(context).secondaryHeaderColor;

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
                        : Theme.of(context).secondaryHeaderColor,
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap:
                          () => showPopupCard(
                            context: context,
                            builder: (context) {
                              return ShowMorePopUp(
                                title: "Tips on your prompt",
                                description: hint,
                              );
                            },
                          ),
                      child: Icon(
                        Icons.question_mark_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
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
                child: Stack(
                  children: [
                    TextField(
                      controller: controller,
                      enabled: enabled,
                      expands: true,
                      maxLines: null,
                      maxLength: maxCharacters,
                      style: kInputPlaceHolderText.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                          right: 10,
                        ),
                        hintText: description,
                        hintStyle: kPlaceHolderTextStyle.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
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
                          borderSide: BorderSide(
                            color: disabledColor,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: type.getColor(),
                            width: 6.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                        counterText: '', // Hide default counter
                      ),
                      onChanged: onChanged,
                    ),
                    Positioned(
                      bottom: 10, // Adjust vertically
                      right: 15, // Adjust horizontally
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, _) {
                          return Text(
                            '${value.text.length}/${maxCharacters}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
