import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// App themes
var kLightTheme = ThemeData(
  fontFamily: 'Poppins',
  platform: TargetPlatform.iOS,
  scaffoldBackgroundColor: kScaffoldColorLight,
  primaryColor: kPrimaryHeaderColorLight,
  secondaryHeaderColor: kSecondaryTextColorLight,
  highlightColor: kCalendarDayTextColorLight,
  cardColor: kTaskTileColorLight,
  canvasColor: kNavBarColorLight,
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStatePropertyAll<Color>(kPrimaryHeaderColorDark),
    checkColor: WidgetStatePropertyAll<Color>(kScaffoldColorDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide.none,
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: kTaskTileColorLight,
    hourMinuteColor: kPrimaryHeaderColorLight,
    hourMinuteTextColor: Colors.black,
    dayPeriodColor: kTaskTileColorLight,
    dayPeriodTextColor: Colors.black,
    dialBackgroundColor: kSecondaryTextColorLight,
    dialHandColor: kPrimaryHeaderColorLight,
    dialTextColor: Colors.black,
    entryModeIconColor: kPrimaryHeaderColorLight,
    helpTextStyle: TextStyle(
      color: kPrimaryHeaderColorLight,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryHeaderColorLight,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);

var kDarkTheme = ThemeData(
  fontFamily: 'Poppins',
  platform: TargetPlatform.iOS,
  scaffoldBackgroundColor: kScaffoldColorDark,
  primaryColor: kPrimaryHeaderColorDark,
  secondaryHeaderColor: kSecondaryTextColorDark,
  cardColor: kTaskTileColorDark,
  highlightColor: kCalendarDayTextColorDark,
  canvasColor: kNavBarColorDark,
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStatePropertyAll<Color>(kPrimaryHeaderColorDark),
    checkColor: WidgetStatePropertyAll<Color>(kScaffoldColorDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide.none,
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: kTaskTileColorDark,
    hourMinuteColor: kPrimaryHeaderColorDark,
    hourMinuteTextColor: Colors.black,
    dayPeriodColor: kScaffoldColorDark,
    dayPeriodTextColor: kPrimaryHeaderColorDark,
    dialBackgroundColor: kScaffoldColorDark,
    dialHandColor: kSecondaryTextColorDark,
    dialTextColor: kPrimaryHeaderColorDark,
    entryModeIconColor: kPrimaryHeaderColorDark,
    helpTextStyle: TextStyle(
      color: kPrimaryHeaderColorDark,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryHeaderColorDark,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);

// Colors
const kScaffoldColorDark = Color(0xFF232323);
const kScaffoldColorLight = Colors.white;

const kNavBarColorDark = Color(0xFF1A1A1A);
const kNavBarColorLight = Color(0xFFE0E0E0);

const kCalendarDayTextColorDark = Color(0xFFc7c7ff);
const kCalendarDayTextColorLight = Color(0xff6961b3);

const kPrimaryHeaderColorDark = Color(0XFFE0E0E0);
const kPrimaryHeaderColorLight = Color(0xFF252222);

const kTaskTileColorDark = Color(0xFF2A2A2A);
const kTaskTileColorLight = Color(0xFFF0F0F0);

const kSecondaryTextColorDark = Color(0XFF7F7F7F);
const kSecondaryTextColorLight = Color(0xFF555555);

const kPhysicalColor = Color(0xFF27AE60);
const kMentalColor = Color(0xFF9B59B6);
const kGeneralColor = Color(0xFF3498DB);

const kMetaLevelColor = Color(0xFF00FF6C);

// Text fields
const kTextFieldDecoration = InputDecoration(
  hintText: 'hintText',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryTextColorDark, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryTextColorDark, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// TextStyle
const kMorphTitleStyle = TextStyle(
  color: kPrimaryHeaderColorLight,
  fontSize: 60.0,
  letterSpacing: 5,
);

const kMorphPhraseStyle = TextStyle(
  color: kSecondaryTextColorLight,
  fontSize: 16.0,
  fontStyle: FontStyle.italic,
  letterSpacing: 5,
);

const kTitleTextStyle = TextStyle(fontSize: 32, letterSpacing: 1);

const kGradientButtonTextSyle = TextStyle(
  color: kPrimaryHeaderColorLight,
  fontSize: 16.5,
);

const kInputPlaceHolderText = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  textBaseline: TextBaseline.alphabetic,
);

const kPlaceHolderTextStyle = TextStyle(
  color: kSecondaryTextColorLight,
  fontSize: 14.0,
  height: 1.3,
  letterSpacing: 2,
);

const kConfirmButtonTextStyle = TextStyle(fontSize: 24, letterSpacing: 1);

const kGoalTitleTextStyle = TextStyle(
  letterSpacing: 1,
  fontSize: 20,
  color: kPrimaryHeaderColorLight,
);
