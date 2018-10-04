// structure for storing taskItem rendering info
class TasksViewConfig {
  double valuePower;
  bool showPastTasks;
  TasksViewConfig({this.valuePower = 3.0, this.showPastTasks = false});

  void update(newConfig) {
    this.valuePower = newConfig.valuePower;
    this.showPastTasks = newConfig.showPastTasks;
  }
}
