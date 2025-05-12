import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/utils/constants.dart';

import '../../model/habit.dart';

class ReadMoreHabitPopUp extends StatefulWidget {
  final Habit habit;

  const ReadMoreHabitPopUp({required this.habit, super.key});

  @override
  State<ReadMoreHabitPopUp> createState() => _ReadMoreHabitPopUpState();
}

class _ReadMoreHabitPopUpState extends State<ReadMoreHabitPopUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Card(
          color: Theme.of(context).cardColor,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                    left: 15.0,
                  ),
                  child: ListTile(
                    title: Text(
                      widget.habit.title,
                      style: kTitleTextStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.habit.description,
                        style: kTitleTextStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
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
