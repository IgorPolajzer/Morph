import 'package:hive/hive.dart';
import '../utils/enums.dart';
import 'experience.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late List<String> completedTasks;

  @HiveField(3)
  late Map<HabitType, Experience> experience;

  @HiveField(4)
  late Map<HabitType, bool> selectedHabits;

  @HiveField(5)
  bool dirty = false;

  @HiveField(6)
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
