import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class ScreenTitle extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ScreenTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: kTitleTextStyle.copyWith(
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
