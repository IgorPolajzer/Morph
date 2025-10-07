import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

import '../state/connectivity_notifier.dart';

bool assertConnectivity(
  ConnectivityNotifier connectivity,
  BuildContext? context,
) {
  /*  if (!connectivity.isConnected) {
    // Show a message to the user
    toastification.show(
      context: context,
      title: Text('No Internet Connection'),
      description: Text('Please check your network and try again.'),
      type: ToastificationType.error,
      autoCloseDuration: Duration(seconds: 3),
    );
    return false;
  }*/
  return true;
}

void somethingWentWrongToast(BuildContext? context) {
  toastification.show(
    context: context,
    title: Text('Something went wrong'),
    description: Text('Please try again later.'),
    type: ToastificationType.error,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void emailOrUsernameAlreadyInUseToast(BuildContext? context) {
  toastification.show(
    context: context,
    title: Text('Email or username already in use'),
    description: Text('Try a different email or username.'),
    type: ToastificationType.error,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void emailNotValidToast(BuildContext? context) {
  toastification.show(
    context: context,
    title: Text("Email isn't valid."),
    description: Text('Enter a valid email.'),
    type: ToastificationType.error,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void customSuccessToast(
  BuildContext? context,
  String title,
  String description,
) {
  toastification.show(
    context: context,
    title: Text(title),
    description: Text(description),
    type: ToastificationType.success,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void customErrorToast(BuildContext? context, String title, String description) {
  toastification.show(
    context: context,
    title: Text(title),
    description: Text(description),
    type: ToastificationType.error,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void customInfoToast(BuildContext? context, String title, String description) {
  toastification.show(
    context: context,
    title: Text(title),
    description: Text(description),
    type: ToastificationType.info,
    autoCloseDuration: Duration(seconds: 3),
  );
}

void firebaseAuthToast(FirebaseAuthException e, BuildContext? context) {
  switch (e.code) {
    case 'invalid-email':
      customErrorToast(
        context,
        'Invalid Email',
        'Please enter a valid email address.',
      );
      break;
    case 'user-disabled':
      customErrorToast(
        context,
        'Account Disabled',
        'This account has been disabled.',
      );
      break;
    case 'user-not-found':
      customErrorToast(
        context,
        'User Not Found',
        'No account found for this email.',
      );
      break;
    case 'wrong-password':
      customErrorToast(
        context,
        'Wrong Password',
        'The password you entered is incorrect.',
      );
      break;
    case 'too-many-requests':
      customErrorToast(context, 'Too Many Attempts', 'Please try again later.');
      break;
    case 'email-already-in-use':
      customErrorToast(
        context,
        'Email In Use',
        'This email is already registered.',
      );
      break;
    case 'operation-not-allowed':
      customErrorToast(
        context,
        'Operation Not Allowed',
        'This sign-up method is not allowed.',
      );
      break;
    case 'weak-password':
      customErrorToast(
        context,
        'Weak Password',
        'Password must be at least 6 characters.',
      );
      break;
    default:
      somethingWentWrongToast(context);
  }
}
