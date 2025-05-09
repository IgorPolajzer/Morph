import 'package:flutter/material.dart';
import 'package:morphe/components/buttons/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toastification/toastification.dart';

import '../utils/constants.dart';
import 'choose_goals_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final FirebaseApp _app;
  late final _auth;
  late String email;
  late String password;
  bool showSpinner = false;

  void setUpAuth() async {
    _app = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: _app);
  }

  @override
  void initState() {
    super.initState();
    setUpAuth();
  }

  @override
  Widget build(BuildContext context) {
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
                          scale: 2,
                        ),
                      ),
                      Hero(
                        tag: 'title',
                        child: Text(
                          "Morph",
                          style: kMorphTitleStyle.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'subtext',
                        child: Text(
                          "Small Habits. Big Change.",
                          style: kMorphPhraseStyle.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
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
                    onChanged: (value) {},
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
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChooseGoalsScreen.id);
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
