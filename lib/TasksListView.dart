import 'package:flutter/material.dart';
import 'TaskListItem.dart';
import 'TasksManager.dart' show tasksManager;
import 'TasksViewConfig.dart';

class TasksListView extends StatelessWidget {
  final TasksViewConfig viewConfig;
  TasksListView(this.viewConfig);

  @override
  Widget build(BuildContext buildContext) {
    return ListView.builder(
      itemCount: tasksManager.tasks.length,
      itemBuilder: (context, index) {
        return new TaskListItem(
            task: tasksManager.tasks[index],
            maxDeadline: tasksManager.maxDeadline,
            minDeadline: tasksManager.minDeadline,
            viewConfig: viewConfig);
      },
    );
  }
}
