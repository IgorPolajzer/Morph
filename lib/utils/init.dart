import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../state/user_data.dart';

Future<UserData> initialize() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize UserData state
  final userData = UserData();
  await userData.initialize(FirebaseAuth.instance.currentUser?.uid);

  // Initialize Mobile Ads
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      'd68e3860-8865-46f9-8339-8ca0d3b248e0',
      '5da57a97-f5d7-4da7-be5c-23f2b71bd3bd',
      '539d28f1-d59f-4e7f-a54e-16227139c841',
    ],
  );

  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  return userData;
}
