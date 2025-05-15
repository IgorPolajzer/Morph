class Experience {
  int points;
  int maxXp;
  int level;

  Experience({this.points = 0, this.maxXp = 100, this.level = 1});

  factory Experience.fromJson(Map<String, dynamic> json) {
    var habit = Experience(
      points: json['points'] ?? 0,
      level: json['level'] ?? 1,
    );

    return habit;
  }

  Map<String, dynamic> toMap() {
    return {'level': level, 'points': points};
  }

  static int getMetaXp(int physicalXp, int generalXp, int mentalXp) {
    return physicalXp + generalXp + mentalXp;
  }
}
