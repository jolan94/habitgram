class Habit {
  String name;
  String description;
  int goalDays;
  int iconIndex;
  bool completed;

  Habit({
    required this.name,
    required this.description,
    required this.goalDays,
    required this.iconIndex,
    this.completed = false,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      description: json['description'],
      goalDays: json['goalDays'],
      iconIndex: json['iconIndex'] ?? 0,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'goalDays': goalDays,
      'iconIndex': iconIndex,
      'completed': completed,
    };
  }
}
