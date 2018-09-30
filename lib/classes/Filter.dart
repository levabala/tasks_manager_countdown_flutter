import 'package:todo_countdown/classes/TaskC.dart';
import 'package:todo_countdown/classes/Range.dart';
import 'dart:convert';

typedef bool FilterCondition(TaskC task);

class Filter {
  String name;
  Range range;
  Filter({this.range = Range.ZERO_TO_ZERO, this.name});

  bool check(TaskC task) {
    var isIn = range.isIn(value: task.deadlineMs);
    return isIn;
  }

  List<TaskC> filterList(List<TaskC> list) {
    return list.where(check).toList();
  }

  String toJSON() {
    Map<String, String> data = {
      "name": name,
      "range": range.toJSON(),
    };
    var json = jsonEncode(data);
    return json;
  }

  static Filter fromJSON(json) {
    var data = jsonDecode(json);
    return Filter(name: data["name"], range: Range.fromJSON(data["range"]));
  }
}
