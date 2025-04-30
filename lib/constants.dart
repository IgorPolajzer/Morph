import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// App themes
var kLightTheme = ThemeData(
  fontFamily: 'Josefin Sans',
  platform: TargetPlatform.iOS,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    displayLarge: TextStyle(color: kPrimaryHeaderColorLight),
    displayMedium: TextStyle(color: kPlaceholderTextColorLight),
    displaySmall: TextStyle(color: kArrowColorLight),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStatePropertyAll<Color>(kPrimaryHeaderColorDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide.none,
  ),
);

var kDarkTheme = ThemeData(
  fontFamily: 'Josefin Sans',
  platform: TargetPlatform.iOS,
  scaffoldBackgroundColor: Color(0xFF232323),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: kPrimaryHeaderColorDark),
    displayMedium: TextStyle(color: kPlaceholderTextColorDark),
    displaySmall: TextStyle(color: kArrowColorDark),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStatePropertyAll<Color>(kPrimaryHeaderColorDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide.none,
  ),
);

// Colors
const kPrimaryHeaderColorDark = Color(0XFFE0E0E0);
const kPrimaryHeaderColorLight = Colors.black54;

const kTaskTileColorDark = Color(0xFF2A2A2A);
const kTaskTileColorLight = Color(0xFF2A2A2A);

const kArrowColorLight = Color(0xFF393939);
const kArrowColorDark = Color(0xFF393939);

const kPlaceholderTextColorDark = Color(0XFF7F7F7F);
const kPlaceholderTextColorLight = Colors.black26;

const kPhysicalColor = Color(0xFF27AE60);
const kMentalColor = Color(0xFF9B59B6);
const kGeneralColor = Color(0xFF3498DB);

// Text fields
const kTextFieldDecoration = InputDecoration(
  hintText: 'hintText',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPlaceholderTextColorDark, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPlaceholderTextColorDark, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// TextStyle
const kMorphTitleStyle = TextStyle(
  inherit: false,
  color: kPrimaryHeaderColorLight,
  fontSize: 60.0,
  fontWeight: FontWeight.w300,
  letterSpacing: 5,
);

const kMorphPhraseStyle = TextStyle(
  inherit: false,
  color: kPlaceholderTextColorLight,
  fontSize: 20.0,
  fontStyle: FontStyle.italic,
  letterSpacing: 5,
);

const kTitleTextStyle = TextStyle(
  inherit: false,
  fontSize: 32,
  fontWeight: FontWeight.w500,
  letterSpacing: 1,
);

const kGradientButtonTextSyle = TextStyle(
  inherit: false,
  color: kPrimaryHeaderColorLight,
  fontSize: 16.5,
  fontWeight: FontWeight.bold,
);

const kInputPlaceHolderText = TextStyle(
  inherit: false,
  color: Colors.black,
  fontSize: 20.0,
  textBaseline: TextBaseline.alphabetic,
);

const kPlaceHolderTextStyle = TextStyle(
  inherit: false,
  color: kPlaceholderTextColorLight,
  fontSize: 14.0,
  height: 1.3,
  letterSpacing: 2,
);

const kConfirmButtonTextStyle = TextStyle(
  inherit: false,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  letterSpacing: 1,
);

const kGoalTitleTextStyle = TextStyle(
  inherit: false,
  fontWeight: FontWeight.w400,
  letterSpacing: 1,
  fontSize: 20,
  color: kPrimaryHeaderColorLight,
);
