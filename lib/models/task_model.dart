class Task {
  final String? objectId;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    this.objectId,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}