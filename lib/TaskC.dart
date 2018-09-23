class TaskC {
  String name;
  double progress;
  DateTime deadline;
  List<String> tags;

  TaskC({name, tags, deadline, progress = 0.0}) {
    this.name = name;
    this.progress = progress;
    this.tags = tags;
    this.deadline = deadline;
  }
}
