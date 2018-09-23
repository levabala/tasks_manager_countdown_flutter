class TaskC {
  String name;
  String description;
  double progress;
  DateTime deadline;
  List<String> tags;

  TaskC({
    this.name,
    this.tags,
    this.deadline,
    this.description = "",
    this.progress = 0.0,
  });
}
