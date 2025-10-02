import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/exceptions/request_exception.dart';
import 'package:morphe/screens/onboarding/plan_overview_screen.dart';
import 'package:morphe/screens/onboarding/register_screen.dart';
import 'package:pair/pair.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/text/screen_title.dart';
import '../../components/text_fields/describe_goal_text_field.dart';
import '../../exceptions/generation_exception.dart';
import '../../model/habit.dart';
import '../../model/task.dart';
import '../../state/user_data.dart';
import '../../utils/enums.dart';
import '../../utils/plan_generator.dart';

class DescribeYourGoalsScreen extends StatefulWidget {
  static String id = '/describe_your_goals_screen';

  const DescribeYourGoalsScreen({super.key});

  @override
  State<DescribeYourGoalsScreen> createState() =>
      _DescribeYourGoalsScreenState();
}

class _DescribeYourGoalsScreenState extends State<DescribeYourGoalsScreen> {
  // Add config
  late InterstitialAd _interstitialAd;
  bool isInterstitialAdReady = false;

  // Text controllers.
  late final TextEditingController physicalController;
  late final TextEditingController generalController;
  late final TextEditingController mentalController;

  // Variables
  final int MAX_CHARACTERS = 250;

  bool showSpinner = false;

  String physicalGoals = "";
  String generalGoals = "";
  String mentalGoals = "";

  @override
  void initState() {
    super.initState();

    // Add setup
    InterstitialAd.load(
      adUnitId: "ca-app-pub-4498572432922231/7920604342",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            isInterstitialAdReady = false;
          });
        },
      ),
    );

    // Controller setup
    physicalController = TextEditingController();
    generalController = TextEditingController();
    mentalController = TextEditingController();

    physicalController.addListener(() {
      physicalGoals = physicalController.text;
    });
    generalController.addListener(() {
      generalGoals = generalController.text;
    });
    mentalController.addListener(() {
      mentalGoals = mentalController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    var physical = userData.user.selectedHabits[HabitType.PHYSICAL] ?? false;
    var general = userData.user.selectedHabits[HabitType.GENERAL] ?? false;
    var mental = userData.user.selectedHabits[HabitType.MENTAL] ?? false;

    return Scaffold(
      appBar: ScreenTitle(title: "DESCRIBE YOUR GOALS"),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DescribeGoalField(
                      type: HabitType.PHYSICAL,
                      title: "PHYSICAL",
                      hint:
                          "Tips for describing physical goals:\n- State your desired outcome (e.g., build muscle, lose fat, increase energy).\n- Mention preferred activities (e.g., running, weightlifting, yoga).\n- Include any constraints or limitations (e.g., no access to gym, previous injury).\n- Add timeline or urgency if relevant (e.g., in 3 months, before summer)",
                      description:
                          "Describe your physical goals.\nExample: I want to reach a healthy bodyfat range, improve my general strength and health. I would like to achieve those goals through weight training and swimming.",
                      enabled: physical,
                      onChanged: (value) {
                        physicalGoals = value;
                      },
                      controller: physicalController,
                      maxCharacters: MAX_CHARACTERS,
                    ),
                    DescribeGoalField(
                      type: HabitType.GENERAL,
                      title: "GENERAL",
                      hint:
                          "Tips for describing general goals:\n- Focus on daily habits or routines (e.g., cleaning, reading, studying).\n- Mention specific tasks or responsibilities you want to be consistent with.\n- Include projects or hobbies you're working on (e.g., learning a language, building an app).\n- Indicate how often or how long you want to work on these (e.g., 3x a week, 15 mins daily).",
                      description:
                          "Describe your general goals.\nExample: I want to improve adhere better to doing my chores more specifically: cleaning my room, reading at least 1 book a month, revising after my classes and working on my personal project “Morphe” at least 5 hours a week.",
                      enabled: general,
                      onChanged: (value) {
                        generalGoals = value;
                      },
                      controller: generalController,
                      maxCharacters: MAX_CHARACTERS,
                    ),
                    DescribeGoalField(
                      type: HabitType.MENTAL,
                      title: "MENTAL",
                      hint:
                          "Tips for describing mental goals:\n- Identify what you want to improve (e.g., focus, memory, mindfulness).\n- Mention emotional goals (e.g., reduce anxiety, increase motivation).\n- Describe situations or patterns you struggle with (e.g., overthinking, low energy in mornings).\n- Note if you're interested in specific methods (e.g., meditation, journaling, therapy techniques).",
                      description:
                          "Describe your mental goals.\nExample: I want to improve my memory, mental clarity and get better at managing stress and anxiety.",
                      enabled: mental,
                      onChanged: (value) {
                        mentalGoals = value;
                      },
                      controller: mentalController,
                      maxCharacters: MAX_CHARACTERS,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(
          enabled: !showSpinner,
          title: "GENERATE",
          onPressed: () async {
            final router = GoRouter.of(context);

            if (physical == physicalGoals.isNotEmpty &&
                general == generalGoals.isNotEmpty &&
                mental == mentalGoals.isNotEmpty) {
              try {
                setState(() {
                  showSpinner = true;
                });

                // Generate plans
                Map<HabitType, String> prompts = {};

                if (physical && physicalGoals.isNotEmpty) {
                  prompts[HabitType.PHYSICAL] = physicalGoals;
                }
                if (general && generalGoals.isNotEmpty) {
                  prompts[HabitType.GENERAL] = generalGoals;
                }
                if (mental && mentalGoals.isNotEmpty) {
                  prompts[HabitType.MENTAL] = mentalGoals;
                }

                await _handleUser(userData, prompts);
                _toPlanOverview(userData.user.selectedHabits);
              } on GenerationException {
                toastification.show(
                  context: context,
                  title: Text('Try again'),
                  description: Text(
                    'Prompts were insufficient. Tap the ? symbols for instructions',
                  ),
                  type: ToastificationType.error,
                  autoCloseDuration: Duration(seconds: 3),
                );
                router.push(DescribeYourGoalsScreen.id);
              } on RequestException {
                toastification.show(
                  context: context,
                  title: Text('Try again'),
                  description: Text(
                    'The prompt exceeded max token count. Try a shorter version.',
                  ),
                  type: ToastificationType.error,
                  autoCloseDuration: Duration(seconds: 3),
                );
                router.push(DescribeYourGoalsScreen.id);
              } catch (e) {
                print(e);
                toastification.show(
                  context: context,
                  title: Text('Try again'),
                  description: Text(
                    'Something went wrong during the registration',
                  ),
                  type: ToastificationType.error,
                  autoCloseDuration: Duration(seconds: 3),
                );
                router.push(RegisterScreen.id);
              } finally {
                physicalController.clear();
                generalController.clear();
                mentalController.clear();
                setState(() {
                  showSpinner = false;
                });
              }
            } else {
              toastification.show(
                context: context,
                title: Text('Empty input boxes'),
                description: Text(
                  'All the goals you chose have to have be described',
                ),
                type: ToastificationType.info,
                autoCloseDuration: Duration(seconds: 3),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd.dispose();

    physicalController.dispose();
    generalController.dispose();
    mentalController.dispose();

    super.dispose();
  }

  Future<void> _handleUser(
    UserData userData,
    Map<HabitType, String> prompts,
  ) async {
    // Show ad
    _showInterstitialAd();

    // Generate plan
    Pair<List<Task>, List<Habit>> plan = await generateAndParse(
      prompts,
      userData.user.selectedHabits,
    );

    //var plan = createHardcodedPlan();

    // Save plan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userData.setTasks(plan.key);
      userData.setHabits(plan.value);
    });

    try {
      if (FirebaseAuth.instance.currentUser == null) {
        // Create user and initialise in firebase if not logged in.

        await userData.createUser();
      } else {
        await userData.patchUser(); // Line of excepiton
        userData.setExecutableTasks(DateTime.now());
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          toastification.show(
            context: context,
            title: Text('Email In Use'),
            description: Text('This email is already registered.'),
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 3),
          );
          break;
        case 'invalid-email':
          toastification.show(
            context: context,
            title: Text('Invalid Email'),
            description: Text('Please enter a valid email address.'),
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 3),
          );
          break;
        case 'operation-not-allowed':
          toastification.show(
            context: context,
            title: Text('Sign-Up Disabled'),
            description: Text('This sign-up method is not allowed.'),
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 3),
          );
          break;
        case 'weak-password':
          toastification.show(
            context: context,
            title: Text('Weak Password'),
            description: Text('Password must be at least 6 characters.'),
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 3),
          );
          break;
        default:
          toastification.show(
            context: context,
            title: Text('Registration Failed'),
            description: Text('Something went wrong during registration.'),
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 3),
          );
      }

      // Re-throw if needed for external handling
      rethrow;
    } catch (e) {
      // Generic fallback
      toastification.show(
        context: context,
        title: Text('Registration Failed'),
        description: Text('Something went wrong during registration.'),
        type: ToastificationType.error,
        autoCloseDuration: Duration(seconds: 3),
      );
      rethrow;
    }
  }

  void _showInterstitialAd() {
    void showNextAd() {
      if (isInterstitialAdReady) {
        _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            setState(() {
              isInterstitialAdReady = false;
            });

            if (showSpinner) {
              // Load next ad, then show it
              InterstitialAd.load(
                adUnitId: "ca-app-pub-4498572432922231/7920604342",
                request: AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(
                  onAdLoaded: (ad) {
                    setState(() {
                      _interstitialAd = ad;
                      isInterstitialAdReady = true;
                    });

                    showNextAd();
                  },
                  onAdFailedToLoad: (error) {
                    debugPrint("Failed to load next ad: $error");
                  },
                ),
              );
            }
          },
        );

        _interstitialAd.show();
      }
    }

    showNextAd();
  }

  void _toPlanOverview(Map<HabitType, bool> selectedHabits) {
    // Navigate to first selected habit type

    // TODO commit functioning version and try to implement with stack

    if (selectedHabits[HabitType.PHYSICAL] ?? false) {
      context.push(PlanOverviewScreen.id_physical);
    } else if (selectedHabits[HabitType.GENERAL] ?? false) {
      context.push(PlanOverviewScreen.id_general);
    } else if (selectedHabits[HabitType.MENTAL] ?? false) {
      context.push(PlanOverviewScreen.id_mental);
    } else {
      throw Exception("No habits chosen");
    }
  }
}

Pair<List<Task>, List<Habit>> createHardcodedPlan() {
  // Habits
  final habits = [
    Habit(
      title: 'Morning Run',
      description: 'Run 3 km every morning to improve cardiovascular health.',
      type: HabitType.PHYSICAL,
      notifications: true,
    ),
    Habit(
      title: 'Read Daily',
      description: 'Read at least 30 minutes every day to expand knowledge.',
      type: HabitType.GENERAL,
      notifications: true,
    ),
    Habit(
      title: 'Meditation',
      description:
          'Meditate for 15 minutes to reduce stress and improve focus.',
      type: HabitType.MENTAL,
      notifications: true,
    ),
  ];

  // Tasks
  final now = DateTime.now();
  final tasks = [
    Task(
      title: 'Run 3 km',
      subtitle: 'Morning exercise',
      description: 'Go for a 3 km run in the morning to stay fit.',
      scheduledFrequency: Frequency.DAILY,
      scheduledDay: Day.MONDAY,
      startDateTime: now,
      endDateTime: now.add(const Duration(hours: 1)),
      type: HabitType.PHYSICAL,
      notifications: true,
    ),
    Task(
      title: 'Read a Book',
      subtitle: 'Daily reading',
      description: 'Spend at least 30 minutes reading a book.',
      scheduledFrequency: Frequency.DAILY,
      scheduledDay: Day.MONDAY,
      startDateTime: now,
      endDateTime: now.add(const Duration(minutes: 30)),
      type: HabitType.GENERAL,
      notifications: true,
    ),
    Task(
      title: 'Meditate',
      subtitle: 'Mindfulness',
      description: 'Meditate for 15 minutes to reduce stress.',
      scheduledFrequency: Frequency.DAILY,
      scheduledDay: Day.MONDAY,
      startDateTime: now,
      endDateTime: now.add(const Duration(minutes: 15)),
      type: HabitType.MENTAL,
      notifications: true,
    ),
  ];

  return Pair(tasks, habits);
}
