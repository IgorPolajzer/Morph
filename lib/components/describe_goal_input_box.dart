import 'package:flutter/material.dart';
import 'package:morphe/constants.dart';

class DescribeGoalInputBox extends StatelessWidget {
  final Color borderColor;
  final String title;
  final String description;
  final String hint;
  final bool enabled;

  const DescribeGoalInputBox({
    required this.borderColor,
    required this.title,
    required this.description,
    required this.hint,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var disabledColor =
        Theme.of(context).textTheme.displayMedium!.color ?? Colors.black54;

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
                color: enabled ? borderColor : disabledColor,
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
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.question_mark_sharp,
                      color: Theme.of(context).textTheme.displayLarge?.color,
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
                  color: enabled ? borderColor : disabledColor,
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
                      color: Theme.of(context).textTheme.displayMedium?.color,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 4.0),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 4.0),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: disabledColor, width: 4.0),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 6.0),
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
