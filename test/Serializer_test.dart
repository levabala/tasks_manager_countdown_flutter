import 'package:tasks_manager_countdown_flutter/Filter.dart';
import 'package:test/test.dart';
import 'package:tasks_manager_countdown_flutter/TasksManager.dart'
    show tasksManager;
import 'package:tasks_manager_countdown_flutter/FiltersManager.dart'
    show filtersManager;
import 'package:tasks_manager_countdown_flutter/Range.dart';
import 'package:tasks_manager_countdown_flutter/TaskC.dart';

void main() {
  test("Task serialization test", () {
    var task = TaskC(
      name: "My task",
      description: "qemrg[qmb[qemb[qerg'qerg]10234+=]'",
      tags: ["uni", "events"],
      progress: 0.3,
      deadline: DateTime.now(),
    );

    var json = task.toJSON();
    var decodedTask = TaskC.fromJSON(json);

    expect(task.name, equals(decodedTask.name));
    expect(task.description, equals(decodedTask.description));
    expect(task.progress, equals(decodedTask.progress));
    expect(task.tags, equals(decodedTask.tags));
    expect(
        (task.deadline.millisecondsSinceEpoch -
                decodedTask.deadline.millisecondsSinceEpoch)
            .abs(),
        lessThan(1 * 1000));
  });

  test("Range serialization test", () {
    var range = new Range(1, 3);

    var json = range.toJSON();
    var decodedTask = Range.fromJSON(json);

    expect(range.from, equals(decodedTask.from));
    expect(range.to, equals(decodedTask.to));
  });

  test("TasksManager serialization test", () {
    var tasks = tasksManager.tasks.toList();
    var maxDeadline = tasksManager.maxDeadline;
    var minDeadline = tasksManager.minDeadline;

    var json = tasksManager.toJSON();
    tasksManager.loadJSONData(json);

    expect(tasks, equals(tasksManager.tasks));
    expect(maxDeadline, equals(tasksManager.maxDeadline));
    expect(minDeadline, equals(tasksManager.minDeadline));
  });

  test("FiltersManager serialization test", () {
    var filters = Map<String, Filter>.from(filtersManager.filters);

    var json = filtersManager.toJSON();
    filtersManager.loadJSONData(json);

    expect(filters, equals(filtersManager.filters));
  });
}
