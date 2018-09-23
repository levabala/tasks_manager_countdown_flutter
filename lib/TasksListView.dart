import 'package:flutter/material.dart';
import 'TaskListItem.dart';
import 'TasksManager.dart' show tasksManager;
import 'TasksViewConfig.dart';

class TasksListView extends StatelessWidget {
  final DateTime maxDeadline = tasksManager.maxDeadline;
  final TasksViewConfig viewConfig;
  TasksListView(this.viewConfig);

  @override
  Widget build(BuildContext buildContext) {
    return ListView.builder(
      itemCount: tasksManager.tasks.length,
      itemBuilder: (context, index) {
        return new TaskListItem(
            tasksManager.tasks[index], maxDeadline, viewConfig);
      },
    );
  }
}
