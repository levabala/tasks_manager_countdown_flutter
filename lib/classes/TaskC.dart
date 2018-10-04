import 'dart:convert';

import 'package:flutter/foundation.dart';

class TaskC {
  String name;
  String description;
  // not using now
  double progress;
  // finish time
  DateTime deadline;
  // shortcut for milliseconds
  int get deadlineMs {
    return deadline.millisecondsSinceEpoch;
  }

  List<String> tags;

  TaskC({
    @required this.name,
    this.tags = const [],
    this.deadline,
    this.description = "",
    this.progress = 0.0,
  });

  String toJSON() {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "progress": progress, //.toString(),
      "deadline": deadline.millisecondsSinceEpoch, //.toString(),
      "tags": tags, //.toString()
    };
    var json = jsonEncode(data);
    return json;
  }

  static TaskC fromJSON(json) {
    var data = jsonDecode(json);
    return TaskC(
        name: data["name"],
        description: data["description"],
        progress: data["progress"],
        tags: List<String>.from(data["tags"]),
        deadline: DateTime.fromMillisecondsSinceEpoch(data["deadline"]));
  }
}
