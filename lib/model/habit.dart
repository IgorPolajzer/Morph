import '../utils/enums.dart';

class Habit {
  String title;
  String description;
  HabitType type;

  Habit({required this.title, required this.description, required this.type});
}
