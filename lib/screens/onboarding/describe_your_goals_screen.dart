import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/model/request_exception.dart';
import 'package:morphe/screens/onboarding/plan_overview_screen.dart';
import 'package:morphe/screens/onboarding/registration_screen.dart';
import 'package:pair/pair.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../components/text/screen_title.dart';
import '../../components/text_fields/describe_goal_text_field.dart';
import '../../model/generation_exception.dart';
import '../../model/habit.dart';
import '../../model/task.dart';
import '../../model/user_data.dart';
import '../../utils/enums.dart';
import 'package:morphe/utils/plan_generator.dart';

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
                    SizedBox(height: 10),
                    DescribeGoalField(
                      type: HabitType.PHYSICAL,
                      title: "PHYSICAL",
                      hint:
                          "Tips for describing physical goals:\n- State your desired outcome (e.g., build muscle, lose fat, increase energy).\n- Mention preferred activities (e.g., running, weightlifting, yoga).\n- Include any constraints or limitations (e.g., no access to gym, previous injury).\n- Add timeline or urgency if relevant (e.g., in 3 months, before summer)",
                      description:
                          "Describe your physical goals.\nExample: I want to reach a healthy bodyfat range, improve my general strength and health. I would like to achieve those goals through weight training and swimming.",
                      enabled: userData.selectedHabits[HabitType.PHYSICAL],
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
                      enabled: userData.selectedHabits[HabitType.GENERAL],
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
                      enabled: userData.selectedHabits[HabitType.MENTAL],
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
            if (userData.selectedHabits[HabitType.PHYSICAL] ==
                    physicalGoals.isNotEmpty &&
                userData.selectedHabits[HabitType.GENERAL] ==
                    generalGoals.isNotEmpty &&
                userData.selectedHabits[HabitType.MENTAL] ==
                    mentalGoals.isNotEmpty) {
              try {
                setState(() {
                  showSpinner = true;
                });
                // Generate plans
                Map<HabitType, String> prompts = {};

                if (userData.selectedHabits[HabitType.PHYSICAL] == true &&
                    physicalGoals.isNotEmpty) {
                  prompts[HabitType.PHYSICAL] = physicalGoals;
                }
                if (userData.selectedHabits[HabitType.GENERAL] == true &&
                    generalGoals.isNotEmpty) {
                  prompts[HabitType.GENERAL] = generalGoals;
                }
                if (userData.selectedHabits[HabitType.MENTAL] == true &&
                    mentalGoals.isNotEmpty) {
                  prompts[HabitType.MENTAL] = mentalGoals;
                }

                _showInterstitialAd();
                Pair<List<Task>, List<Habit>> plan = await generateAndParse(
                  prompts,
                  userData.selectedHabits,
                );
                userData.setTasks(plan.key);
                userData.setHabits(plan.value);

                _toPlanOverview(userData);
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
                context.go(DescribeYourGoalsScreen.id);
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
                context.go(DescribeYourGoalsScreen.id);
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
                context.go(RegistrationScreen.id);
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
                  'All the goals you chose have to have a description',
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

  void _showInterstitialAd() {
    if (isInterstitialAdReady) {
      _interstitialAd.show();
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          setState(() {
            isInterstitialAdReady = false;
          });

          // load new ad
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
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          setState(() {
            isInterstitialAdReady = false;
          });
        },
      );
    }
  }

  void _toPlanOverview(UserData userData) {
    // Navigate to first selected habit type
    var selectedHabits = userData.selectedHabits;

    if (selectedHabits[HabitType.PHYSICAL])
      context.go(PlanOverviewScreen.id_physical);
    else if (selectedHabits[HabitType.GENERAL])
      context.go(PlanOverviewScreen.id_general);
    else if (selectedHabits[HabitType.MENTAL])
      context.go(PlanOverviewScreen.id_mental);
    else
      throw Exception("No habits choosen");
  }
}
