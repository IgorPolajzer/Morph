import '../utils/enums.dart';
import 'experience.dart';

class UserModel {
  late final String email;
  late final String username;
  late final List<String> completedTasks;
  late final Map<HabitType, Experience> experience;
  late final Map<HabitType, bool> selectedHabits;

  UserModel() {
    completedTasks = [];
    experience = {};
    selectedHabits = {};
    for (var habitType in HabitType.values) {
      experience[habitType] = Experience();
      selectedHabits[habitType] = false;
    }
  }

  UserModel.populate(
    this.email,
    this.username,
    this.completedTasks,
    this.experience,
    this.selectedHabits,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Deserialize experience map
    final expMap = <HabitType, Experience>{};
    if (json['experience'] != null) {
      (json['experience'] as Map<String, dynamic>).forEach((key, value) {
        final habitType = HabitType.getTypeFromString(key);
        expMap[habitType] = Experience.fromJson(
          Map<String, dynamic>.from(value),
        );
      });
    }

    // Deserialize selected habits
    final selected = <HabitType, bool>{};
    if (json['selectedHabits'] != null) {
      (json['selectedHabits'] as Map<String, dynamic>).forEach((key, value) {
        final habitType = HabitType.getTypeFromString(key);
        selected[habitType] = value ?? false;
      });
    }

    return UserModel.populate(
      json['email'] ?? '',
      json['username'] ?? '',
      List<String>.from(json['completedTasks'] ?? []),
      expMap,
      selected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'completedTasks': completedTasks,
      'experience': experience.map(
        (k, v) => MapEntry(k.name.toLowerCase(), v.toMap()),
      ),
      'selectedHabits': selectedHabits.map(
        (k, v) => MapEntry(k.name.toLowerCase(), v),
      ),
    };
  }
}
