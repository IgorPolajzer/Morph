class Experience {
  int points;
  int maxXp;
  int level;

  Experience({this.points = 0, this.maxXp = 100, this.level = 1});

  Map<String, dynamic> toMap() {
    return {'level': level, 'points': points};
  }
}
