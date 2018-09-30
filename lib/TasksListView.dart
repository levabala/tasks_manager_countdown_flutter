import 'package:flutter/material.dart';
import 'package:tasks_manager_countdown_flutter/Filter.dart';
import 'package:tasks_manager_countdown_flutter/TaskC.dart';
import 'TaskListItem.dart';
import 'TasksManager.dart' show tasksManager;
import 'TasksViewConfig.dart';
import 'package:tasks_manager_countdown_flutter/FiltersManager.dart'
    show filtersManager;

class TasksListView extends StatelessWidget {
  final TasksViewConfig viewConfig;
  TasksListView(this.viewConfig);

  @override
  Widget build(BuildContext buildContext) {
    if (!filtersManager.filters.containsKey("filter1"))
      filtersManager.setFilter("filter1", Filter());
    List<TaskC> tasksFiltered =
        filtersManager.filters["filter1"].filterList(tasksManager.tasks);
    DateTime maxDeadline, minDeadline;
    maxDeadline = minDeadline = DateTime.now();
    if (tasksFiltered.length > 0) {
      maxDeadline = tasksFiltered
          .reduce((maxTask, task) =>
              task.deadlineMs > maxTask.deadlineMs ? task : maxTask)
          .deadline;
      minDeadline = tasksFiltered
          .reduce((minTask, task) =>
              task.deadlineMs < minTask.deadlineMs ? task : minTask)
          .deadline;
    }

    return ListView.builder(
      itemCount: tasksFiltered.length,
      itemBuilder: (context, index) {
        return new TaskListItem(
            task: tasksFiltered[index],
            maxDeadline: maxDeadline,
            minDeadline: minDeadline,
            viewConfig: viewConfig);
      },
    );
  }
}
