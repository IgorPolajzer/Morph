import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/buttons/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../model/user_data.dart';
import '../utils/constants.dart';
import 'choose_goals_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String username;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);

    late OutlineInputBorder enabledOutlineInputBorder;
    late OutlineInputBorder focusedOutlineInputBorder;

    enabledOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).secondaryHeaderColor,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    );

    focusedOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'image',
                        child: Image.asset(
                          "assets/images/logo_v2.png",
                          scale: 3,
                        ),
                      ),
                      Hero(
                        tag: 'title',
                        child: Text(
                          "Morph",
                          style: kMorphTitleStyle.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'subtext',
                        child: Text(
                          "Small Habits. Big Change.",
                          style: kMorphPhraseStyle.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: kInputPlaceHolderText.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Create your username',
                      hintStyle: kInputPlaceHolderText.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      enabledBorder: enabledOutlineInputBorder,
                      focusedBorder: focusedOutlineInputBorder,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: kInputPlaceHolderText.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Create your email',
                      hintStyle: kInputPlaceHolderText.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      enabledBorder: enabledOutlineInputBorder,
                      focusedBorder: focusedOutlineInputBorder,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    style: kInputPlaceHolderText.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Create your password',
                      hintStyle: kInputPlaceHolderText.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      enabledBorder: enabledOutlineInputBorder,
                      focusedBorder: focusedOutlineInputBorder,
                    ),
                  ),
                ],
              ),
              GradientButton(
                myGradient: LinearGradient(
                  colors: [kPhysicalColor, kGeneralColor, kMentalColor],
                ),
                title: "Register",
                onPressed: () async {
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    // Check if email is in use
                    QuerySnapshot emailQuery =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where("email", isEqualTo: email)
                            .get();

                    QuerySnapshot usernameQuery =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where("username", isEqualTo: username)
                            .get();

                    if (emailQuery.docs.isNotEmpty ||
                        usernameQuery.docs.isNotEmpty) {
                      toastification.show(
                        context: context,
                        title: Text('Email or username already in use'),
                        description: Text('Try a different email or username'),
                        type: ToastificationType.error,
                        autoCloseDuration: Duration(seconds: 3),
                      );
                    } else {
                      userData.setCredentials(email, username, password);
                      context.go(ChooseGoalsScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);

                    toastification.show(
                      context: context,
                      title: Text('Try again'),
                      description: Text('Something went wrong'),
                      type: ToastificationType.error,
                      autoCloseDuration: Duration(seconds: 3),
                    );

                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
