import '../utils/enums.dart';
import 'experience.dart';

class UserModel {
  late String email;
  late String username;
  late List<String> completedTasks;
  late Map<HabitType, Experience> experience;
  late Map<HabitType, bool> selectedHabits;
  bool dirty = false;
  bool deleted = false;

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

  /// Immutable update helper
  UserModel copyWith({
    String? email,
    String? username,
    List<String>? completedTasks,
    Map<HabitType, Experience>? experience,
    Map<HabitType, bool>? selectedHabits,
    bool? dirty,
    bool? deleted,
  }) {
    final newUser = UserModel.populate(
      email ?? this.email,
      username ?? this.username,
      completedTasks ?? List.from(this.completedTasks),
      experience ?? Map.from(this.experience),
      selectedHabits ?? Map.from(this.selectedHabits),
    );
    newUser.dirty = dirty ?? this.dirty;
    newUser.deleted = deleted ?? this.deleted;
    return newUser;
  }

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
