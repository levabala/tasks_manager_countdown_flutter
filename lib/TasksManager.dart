import 'TaskC.dart';

class _TasksManager {
  DateTime maxDeadline = DateTime.fromMicrosecondsSinceEpoch(0);
  List<TaskC> tasks = [];

  void addTask(TaskC task) {
    tasks.add(task);
    if (task.deadline.compareTo(maxDeadline) == 1) maxDeadline = task.deadline;
    tasks.sort((task1, task2) {
      return task1.deadline.compareTo(task2.deadline);
    });
  }

  void addTasks(List<TaskC> tasks) {
    for (TaskC task in tasks) addTask(task);
  }
}

_TasksManager tasksManager = _TasksManager();
