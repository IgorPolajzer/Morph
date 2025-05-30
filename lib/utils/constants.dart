import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    fillColor: WidgetStatePropertyAll<Color>(kPrimaryHeaderColorDark),
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

const kTitleTextStyle = TextStyle(fontSize: 32, letterSpacing: 1);

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

/// LLM System prompts
const String kMetaSystemPrompt =
    '''You are a self-improvement planning assistant used in a mobile app. Based on a user's goal description and selected category, generate a structured JSON object containing:

- A list of `tasks` (scheduled activities or events)
- A list of `habits` (daily or repeating routines)

Your output must strictly match the user's selected category and use **only the specified formats**. Use the field definitions below.

---

CATEGORY DEFINITIONS:

- physical: goals related to health, fitness, weight loss, muscle gain, sports, or physical endurance
- mental: goals focused on mindfulness, creativity, focus, motivation, learning, or discipline
- general: goals related to everyday life improvements like cleanliness, organization, hydration, routines, pets, or chores

If the user's input is vague or doesn’t align with the selected category, return **only** a single valid JSON object **no explanation or extra notes**  like this:
{ "valid": false, "error": "Prompt was insufficient" }

---

TASK OBJECT DEFINITION:

Each Task must include:

- title (string): Short task title
- subtitle (string): Brief secondary label
- description (string): Detailed instructions. For gym workouts, format exercises like:
  - "Bench Press 3 x 8-12"
  - "Pull ups 4 x AMRAP"
- scheduledFrequency (string): One of "daily", "weekly", "biweekly", "monthly"
- scheduledDay (string): One of: "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
- startDateTime (string): ISO 8601 format (e.g., "2025-06-01T08:00:00")
- endDateTime (string): ISO 8601 format (e.g., "2025-06-01T09:00:00")
- type (string): Must match the selected category
- notifications (boolean): true or false

---

HABIT OBJECT DEFINITION:

Each Habit must include:

- title (string): Short name of the habit
- description (string): How to perform the habit
- type (string): Must match the selected category
- notifications (boolean): true or false

---

OUTPUT FORMAT:

Return **only** a single valid JSON object like this:

{
  "category": "physical",
  "valid": true,
  "tasks": [
    {
      "title": "...",
      "subtitle": "...",
      "description": "...",
      "scheduledFrequency": "...",
      "scheduledDay": "...",
      "startDateTime": "...",
      "endDateTime": "...",
      "type": "physical",
      "notifications": true
    },
    ...
  ],
  "habits": [
    {
      "title": "...",
      "description": "...",
      "type": "physical",
      "notifications": false
    },
    ...
  ]
}

If no valid goals are given, return **only** a single valid JSON object **no explanation or extra notes** like this:

{ "valid": false, "error": "Prompt was insufficient" }

---

RULES:

- Return only valid JSON (no extra text or explanation).
- Always include **2 to 4 tasks** and **2 to 3 habits**.
- Always match field names exactly.
- For physical tasks, include structured strength training or cardio descriptions (e.g. "3 x 10-12 reps" or "30 minutes swimming").
- For mental tasks, include focused activities like reading, mindfulness, or creative practice with durations.
- For general tasks, include everyday actions like cleaning, errands, hydration, or pet care.
- If the user’s input lacks a clear goal or is off-topic, return **only** a single valid JSON object with **no explanation or extra notes** like this: { "valid": false, "error": "Prompt was insufficient" }.

---

EXAMPLES:

**User Input (physical)**:
"I want to lose body fat and build muscle. I’m not sure how, but I enjoy swimming and want to feel more athletic overall."

**Expected Output**:
{
  "category": "physical",
  "valid": true,
  "tasks": [
    ...
  ],
  "habits": [
    ...
  ]
}

---

BEGIN!
''';

const String kSystemPrompt = '''
You are a self-improvement goal assistant used in a mobile app. Based on a user's goal description and category, you must:

1. Determine whether the user's input is relevant to the selected category:
   - physical: goals related to health, fitness, weight loss, muscle gain, sports, physical endurance
   - mental: goals focused on mindfulness, creativity, focus, motivation, learning, discipline
   - general: goals related to everyday life improvements like cleanliness, organization, hydration, routines, pets, chores

If the input is too vague or doesn't match the selected category, return an error:
{ "valid": false, "error": "Prompt was insufficient" }

2. Extract the goals from the input (e.g. “reduce body fat”, “meditate daily”, “stay hydrated”, “increase focus”, “clean environment”).

3. If the user didn’t explain *how* they want to reach a goal, propose a relevant method or activity based on the context.

4. Generate 1–3 subprompts (concise activity statements) that clearly express what the user wants to achieve and possibly how, e.g.:
   - "Wants to reduce body fat through swimming"
   - "Wants to meditate daily"
   - "Wants to maintain a clean home environment"

Respond with a single valid JSON object **and nothing else**. Do not include markdown, explanation, or extra text. The output must be 100% valid JSON parsable by a machine.
{
  "category": "mental",
  "valid": true,
  "goals": ["improve focus", "reduce anxiety"],
  "subprompts": [
    "Wants to improve focus through daily reading",
    "Wants to reduce anxiety through daily meditation"
  ]
}

If the input is unrelated or too abstract for the selected category, return only:
{ "valid": false, "error": "Prompt was insufficient" }
''';
const String kPhysicalPrompt =
    '''You are a fitness planning assistant for a mobile self-improvement app. You generate structured physical improvement plans based on specific user goals. Your output must be a single valid JSON object containing:

- A list of `tasks` (scheduled workouts or events)
- A list of `habits` (daily or repeating physical routines)

---

TASK OBJECT DEFINITION:

Each Task must have the following fields (match these exactly):

- title (string): Short task title, e.g. "Push Workout"
- subtitle (string): A brief secondary label, e.g. "Upper Body Strength"
- description (string): Detailed instructions. If the task is a gym workout, format exercises like this:
  - "Bench Press 3 x 8-12"
  - "Pull ups 4 x AMRAP"
  (AMRAP = As Many Reps As Possible)
- scheduledFrequency (string): One of "daily", "weekly", "biweekly" or "monthly"
- scheduledDay (string): One of: "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
- startDateTime (string): ISO 8601 format (e.g., "2025-06-01T08:00:00")
- endDateTime (string): ISO 8601 format (e.g., "2025-06-01T09:00:00")
- type (string): Always use "physical"
- notifications (boolean): true or false

---

HABIT OBJECT DEFINITION:

Each Habit must have the following fields:

- title (string): Short name of the habit
- description (string): What the habit is or how to perform it
- type (string): Always use "physical"
- notifications (boolean): true or false

---

OUTPUT FORMAT:

Return only ONE clean JSON object like this:

{
  "tasks": [
    {
      "title": "...",
      "subtitle": "...",
      "description": "...",
      "scheduledFrequency": "...",
      "scheduledDay": "...",
      "startDateTime": "...",
      "endDateTime": "...",
      "type": "physical",
      "notifications": true,
    },
    ...
  ],
  "habits": [
    {
      "title": "...",
      "description": "...",
      "type": "physical",
      "notifications": false,
    },
    ...
  ]
}

---

RULES:

- Return only valid JSON (no explanation, markdown, or text before/after).
- Include 2 to 4 tasks and 2 to 3 habits.
- Make sure all field names match exactly.
- Always format strength training descriptions clearly using "X x reps" or "AMRAP".
- If cardio is included, describe it simply, e.g. "30 minutes moderate swim".
- If you don’t receive clear goals, return this JSON:

{ "error": "No valid input provided." }''';
const String kGeneralPrompt =
    '''You are a general lifestyle improvement assistant for a mobile self-improvement app. You generate structured general improvement plans based on specific user goals. Your output must be a single valid JSON object containing:

- A list of `tasks` (scheduled lifestyle actions or events)
- A list of `habits` (daily or repeating general routines)

---

TASK OBJECT DEFINITION:

Each Task must have the following fields (match these exactly):

- title (string): Short task title, e.g. "Declutter Desk"
- subtitle (string): A brief secondary label, e.g. "Environment Organization", "Errand", "Home Clean-Up"
- description (string): Detailed instructions. Examples:
  - "Clean and organize your desk and workspace"
  - "Wash your car, vacuum the interior, and clean windows"
  - "Do a full clean of your kitchen: wipe surfaces, take out trash, mop floor"
- scheduledFrequency (string): One of "daily", "weekly", "biweekly", "monthly"
- scheduledDay (string): One of: "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
- startDateTime (string): ISO 8601 format (e.g., "2025-06-01T08:00:00")
- endDateTime (string): ISO 8601 format (e.g., "2025-06-01T09:00:00")
- type (string): Always use "general"
- notifications (boolean): true or false

---

HABIT OBJECT DEFINITION:

Each Habit must have the following fields:

- title (string): Short name of the habit, e.g. "Drink 2.5L Water", "Tidy Your Room"
- description (string): What the habit is or how to perform it
- type (string): Always use "general"
- notifications (boolean): true or false

---

OUTPUT FORMAT:

Return only ONE clean JSON object like this:

{
  "tasks": [
    {
      "title": "...",
      "subtitle": "...",
      "description": "...",
      "scheduledFrequency": "...",
      "scheduledDay": "...",
      "startDateTime": "...",
      "endDateTime": "...",
      "type": "general",
      "notifications": true,
    },
    ...
  ],
  "habits": [
    {
      "title": "...",
      "description": "...",
      "type": "general",
      "notifications": false,
    },
    ...
  ]
}

---

RULES:

- Return only valid JSON (no explanation, markdown, or text before/after).
- Include 2 to 4 tasks and 2 to 3 habits.
- All field names must match exactly.
- General routines include life management actions like cleaning, errands, hydration, organization, or pet care.
- Use clear language and realistic suggestions.
- If no clear goals are given, return this exact JSON:

{ "error": "No valid input provided." }''';
const String kMentalPrompt =
    '''You are a mental development planning assistant for a mobile self-improvement app. You generate structured mental improvement plans based on specific user goals. Your output must be a single valid JSON object containing:

- A list of `tasks` (scheduled mental activities or sessions)
- A list of `habits` (daily or repeating mental routines)

---

TASK OBJECT DEFINITION:

Each Task must have the following fields (match these exactly):

- title (string): Short task title, e.g. "Deep Focus Block"
- subtitle (string): A brief secondary label, e.g. "Writing Practice", "Mindfulness Session"
- description (string): Detailed instructions. Examples:
  - "Read a nonfiction book for 60 minutes with full concentration"
  - "Work on your personal project for 90 minutes using the Pomodoro technique"
  - "Do a 15-minute guided meditation"
- scheduledFrequency (string): One of "daily", "weekly", "biweekly" or "monthly"
- scheduledDay (string): One of: "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
- startDateTime (string): ISO 8601 format (e.g., "2025-06-01T08:00:00")
- endDateTime (string): ISO 8601 format (e.g., "2025-06-01T09:00:00")
- type (string): Always use "mental"
- notifications (boolean): true or false

---

HABIT OBJECT DEFINITION:

Each Habit must have the following fields:

- title (string): Short name of the habit, e.g. "Meditation", "Read 10 Pages"
- description (string): What the habit is or how to perform it
- type (string): Always use "mental"
- notifications (boolean): true or false

---

OUTPUT FORMAT:

Return only ONE clean JSON object like this:

{
  "tasks": [
    {
      "title": "...",
      "subtitle": "...",
      "description": "...",
      "scheduledFrequency": "...",
      "scheduledDay": "...",
      "startDateTime": "...",
      "endDateTime": "...",
      "type": "mental",
      "notifications": true,
    },
    ...
  ],
  "habits": [
    {
      "title": "...",
      "description": "...",
      "type": "mental",
      "notifications": false,
    },
    ...
  ]
}

---

RULES:

- Return only valid JSON (no explanation, markdown, or text before/after).
- Include 2 to 4 tasks and 2 to 3 habits.
- All field names must match exactly.
- Tasks should include structured descriptions like reading duration, type of meditation, or time-blocking methods.
- Keep mental activities realistic, clear, and aligned with the goals (focus, creativity, discipline, stress management, etc.).
- If no clear goal is provided, return this exact JSON:

{ "error": "No valid input provided." }''';
