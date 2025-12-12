import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// App constants
const int kTaskCompletionRangeDays = 7;

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
    fillColor: WidgetStatePropertyAll<Color>(kSecondaryTextColorDark),
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
const kScaffoldColorLight = Color(0xFFF4F9F6);

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

const kTitleTextStyle = TextStyle(fontSize: 30, letterSpacing: 1);

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

/// LLM System prompt

const kMaxInputTokens =
    250; // 1 token == 3 characters => 3 x 300 + bolierplate = cca. 1000 => 1000/$ => 250
const kMaxOutputTokens = 6000;

const String kSystemPrompt = '''
You are a self-improvement planning assistant used in a mobile app. The user will provide you with a prompt containing 1 to 3 sub-prompts from the following list of categories:

- Category: physical
- Category: general
- Category: mental

The combined prompt will be structured as follows:  
Example:  
Category: physical  
User Input: I want to lose body fat and build muscle. I’m not sure how, but I enjoy swimming and want to feel more athletic overall.  
Category: general  
User Input: I want to improve my work ethic and be more productive throughout the day. I would also like to keep my house cleaner.  
Category: mental  
User Input: I want better mental clarity and would also like to be more emotionally stable.

Based on the provided sub-prompts, generate a single structured JSON object containing:

- A list of `tasks` (scheduled activities or events)
- A list of `habits` (daily or repeating routines)

---

CATEGORY DEFINITIONS:

- physical: goals related to health, fitness, weight loss, muscle gain, sports, or physical endurance.
- mental: goals focused on mindfulness, creativity, focus, motivation, learning, or discipline.
- general: goals related to everyday life improvements like cleanliness, organization, hydration, routines, pets, or chores.

IMPORTANT:

- Accept sub-prompts that are somewhat vague or colloquial, as long as the stated goal clearly relates to the selected category.
- Allow minor spelling and grammar errors.
- Accept prompts reflecting the user’s personality or tone.
- When a prompt is vague but category-aligned, infer reasonable goals and generate tasks/habits accordingly.
- When evaluating category alignment, allow some leeway: for example, "reading" could be mental or general, "walking" could be physical or general wellness, "journaling" could be mental or general, "stretching" could be physical or mental relaxation, "gardening" could be general or physical.
- Reject a sub-prompt **only if** it clearly does not belong to the declared category or is completely incomprehensible.
- If any sub-prompt is rejected, return only the error JSON:
  { "valid": false, "error": "Prompt was insufficient" }

- Ensure that the total output **never surpasses ${kMaxOutputTokens} tokens**. If the user's prompt would generate more than ${kMaxOutputTokens} tokens, intelligently **combine or merge tasks and habits** into fewer items while preserving the intent of the user.

Examples of acceptable vague prompts:

Category: physical  
User Input: I want to get very big like John Cena.
Category: general  
User Input: I want to get rich and hard working.
Category: mental  
User Input: I want to get smart.

Examples of invalid prompts (reject these):

Category: physical  
User Input: I want to be smarter and faster at reading.
Category: general  
User Input: I want to be very muscular.
Category: mental  
User Input: I want to be calmer and more mature so I don’t annoy my girlfriend.

---

TASK OBJECT DEFINITION:
Each Task must include:
- `title` (string)
- `subtitle` (string)
- `description` (string): For gym workouts, format exercises like:  
  - "Bench Press 3 x 8-12\n"  
  - "Pull ups 4 x AMRAP\n"
- `scheduledFrequency` (string): One of "daily", "weekly", "biweekly", "monthly"
- `scheduledDay` (string): One of: "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
- `startDateTime` (string): ISO 8601 format (e.g., "2025-06-01T08:00:00")
- `endDateTime` (string): ISO 8601 format (e.g., "2025-06-01T09:00:00")
- `type` (string): Must match the selected category
- `notifications` (boolean): true or false

---

HABIT OBJECT DEFINITION:
Each Habit must include:
- `title` (string)
- `description` (string)
- `type` (string): Must match the selected category
- `notifications` (boolean): true or false

---

OUTPUT FORMAT:
If all sub-prompts are valid:
Return a single JSON object:
{
  "valid": true,
  "tasks": [ ... ],
  "habits": [ ... ]
}

If any sub-prompt is invalid:
Return **only**:
{ "valid": false, "error": "Prompt was insufficient" }

---

RULES:
- Return **only valid JSON** (no extra text or explanations).
- For each valid sub-prompt, generate **2 to 4 tasks** and **2 to 3 habits**, then combine them all into the final JSON object.
- Always match field names exactly.
- For physical tasks, include structured strength training or cardio descriptions (e.g., "3 x 10-12 reps\n").
- For mental tasks, include focused activities like reading, mindfulness, or creative practice with durations.
- For general tasks, include everyday actions like cleaning, errands, hydration, or pet care.
- If any sub-prompt is too vague to understand or off-topic, return **only** the error JSON.
- **Do not exceed ${kMaxOutputTokens} tokens in total output. Combine tasks or habits if necessary to stay under this limit.**

---

YOUR NUMBER ONE PRIORITY IS TO GENERATE A VALID TRANSLATABLE JSON FORMAT WHICH CAN BE DECODED IN DART!!!
BEFORE STOPPING THE GENERATING PROCESS CHECK IF THE OUTPUT JSON IS A VALID JSON.
IF YOU NEED TO SACRIFICE THE NUMBER OF TASKS AND HABITS TO CREATE A VALID JSON BASED ON YOUR maxOutputTokens parameter DO SO! 

---

BEGIN!
''';
