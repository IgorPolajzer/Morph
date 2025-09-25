import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/buttons/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:morphe/screens/core/your_day_screen.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../state/user_data.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final userData = Provider.of<UserData>(context, listen: true);

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
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            style: kMorphTitleStyle.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 32, // Final font size
                            ),
                            child: Text("Morph"),
                          ),
                        ),
                      ),

                      Hero(
                        tag: 'subtext',
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            style: kMorphPhraseStyle.copyWith(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 12, // Final font size
                            ),
                            child: Text(
                              "Small Habits. Big Change.",
                              textAlign: TextAlign.center,
                            ),
                          ),
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
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
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
                      hintText: 'Enter your password',
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
                title: "Login",
                onPressed: () async {
                  final router = GoRouter.of(context);

                  try {
                    setState(() {
                      showSpinner = true;
                    });

                    final user = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (user != null) {
                      if (!userData.loading && !userData.isInitialized) {
                        userData.initialize(
                          FirebaseAuth.instance.currentUser?.uid,
                        );
                      }
                      router.push(YourDayScreen.id);
                    }
                  } on FirebaseAuthException catch (e) {
                    print(e);

                    switch (e.code) {
                      case 'invalid-email':
                        toastification.show(
                          context: context,
                          title: Text('Invalid Email'),
                          description: Text(
                            'Please enter a valid email address.',
                          ),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                        break;
                      case 'user-disabled':
                        toastification.show(
                          context: context,
                          title: Text('Account Disabled'),
                          description: Text('This account has been disabled.'),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                        break;
                      case 'user-not-found':
                        toastification.show(
                          context: context,
                          title: Text('User Not Found'),
                          description: Text('No account found for this email.'),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                        break;
                      case 'wrong-password':
                        toastification.show(
                          context: context,
                          title: Text('Wrong Password'),
                          description: Text(
                            'The password you entered is incorrect.',
                          ),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                        break;
                      case 'too-many-requests':
                        toastification.show(
                          context: context,
                          title: Text('Too Many Attempts'),
                          description: Text('Please try again later.'),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                        break;
                      default:
                        toastification.show(
                          context: context,
                          title: Text('Login Failed'),
                          description: Text(
                            'Something went wrong. Please try again.',
                          ),
                          type: ToastificationType.error,
                          autoCloseDuration: Duration(seconds: 3),
                        );
                    }
                  } catch (e) {
                    print(e);

                    toastification.show(
                      context: context,
                      title: Text('Login Failed'),
                      description: Text(
                        'Something went wrong. Please try again.',
                      ),
                      type: ToastificationType.error,
                      autoCloseDuration: Duration(seconds: 3),
                    );
                  } finally {
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
