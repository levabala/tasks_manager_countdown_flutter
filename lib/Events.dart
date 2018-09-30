import 'package:event_bus/event_bus.dart';
import 'package:todo_countdown/TaskC.dart';

EventBus eventBus = new EventBus();

class TasksAddedEvent {
  List<TaskC> tasks;
  TasksAddedEvent(this.tasks);
}

class TasksRemovedEvent {
  List<TaskC> tasks;
  TasksRemovedEvent(this.tasks);
}
