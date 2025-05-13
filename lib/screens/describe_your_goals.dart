import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/components/buttons/goal_radio_button.dart';
import 'package:morphe/screens/plan_overview_screen.dart';
import 'package:morphe/screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../components/text_fields/describe_goal_text_field.dart';
import '../components/text/screen_title.dart';
import '../model/user_data.dart';
import '../utils/enums.dart';

class DescribeYourGoals extends StatefulWidget {
  static String id = '/describe_your_goals_screen';

  const DescribeYourGoals({super.key});

  @override
  State<DescribeYourGoals> createState() => _DescribeYourGoalsState();
}

class _DescribeYourGoalsState extends State<DescribeYourGoals> {
  late final FirebaseApp _app;
  late final _auth;

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
    final user = Provider.of<UserData>(context, listen: true);
    String physicalGoals = "";
    String generalGoals = "";
    String mentalGoals = "";

    return Scaffold(
      appBar: ScreenTitle(title: "DESCRIBE YOUR GOALS"),
      body: Column(
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
                    enabled: user.getSelectedHabits[HabitType.PHYSICAL],
                    onChanged: (value) {
                      physicalGoals = value;
                    },
                  ),
                  DescribeGoalField(
                    type: HabitType.GENERAL,
                    title: "GENERAL",
                    hint:
                        "Tips for describing general goals:\n- Focus on daily habits or routines (e.g., cleaning, reading, studying).\n- Mention specific tasks or responsibilities you want to be consistent with.\n- Include projects or hobbies you're working on (e.g., learning a language, building an app).\n- Indicate how often or how long you want to work on these (e.g., 3x a week, 15 mins daily).",
                    description:
                        "Describe your general goals.\nExample: I want to improve adhere better to doing my chores more specifically: cleaning my room, reading at least 1 book a month, revising after my classes and working on my personal project “Morphe” at least 5 hours a week.",
                    enabled: user.getSelectedHabits[HabitType.GENERAL],
                    onChanged: (value) {
                      generalGoals = value;
                    },
                  ),
                  DescribeGoalField(
                    type: HabitType.MENTAL,
                    title: "MENTAL",
                    hint:
                        "Tips for describing mental goals:\n- Identify what you want to improve (e.g., focus, memory, mindfulness).\n- Mention emotional goals (e.g., reduce anxiety, increase motivation).\n- Describe situations or patterns you struggle with (e.g., overthinking, low energy in mornings).\n- Note if you're interested in specific methods (e.g., meditation, journaling, therapy techniques).",
                    description:
                        "Describe your mental goals.\nExample: I want to improve my memory, mental clarity and get better at managing stress and anxiety.",
                    enabled: user.getSelectedHabits[HabitType.MENTAL],
                    onChanged: (value) {
                      mentalGoals = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(
          title: "GENERATE",
          onPressed: () async {
            if (user.getSelectedHabits[HabitType.PHYSICAL] ==
                    physicalGoals.isNotEmpty &&
                user.getSelectedHabits[HabitType.GENERAL] ==
                    generalGoals.isNotEmpty &&
                user.getSelectedHabits[HabitType.MENTAL] ==
                    mentalGoals.isNotEmpty) {
              print("$physicalGoals $generalGoals $mentalGoals");
              try {
                // Register user
                final newUser = await _auth.createUserWithEmailAndPassword(
                  email: user.email,
                  password: user.password,
                );
                if (newUser != null) {
                  user.pushToFirebase();
                  Navigator.pushNamed(context, PlanOverviewScreen.id_physical);
                } else
                  throw Exception("newUser is null");
              } catch (e) {
                toastification.show(
                  context: context,
                  title: Text('Try again'),
                  description: Text(
                    'Something went wrong during the registration',
                  ),
                  type: ToastificationType.error,
                  autoCloseDuration: Duration(seconds: 3),
                );
                Navigator.pushNamed(context, RegistrationScreen.id);
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
}
