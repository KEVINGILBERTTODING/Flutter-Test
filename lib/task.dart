class Task {
  final int? id;
  final String task;
  final String date;

  Task({this.id, required this.task, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'date': date,
    };
  }
}
