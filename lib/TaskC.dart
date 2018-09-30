import 'dart:convert';

class TaskC {
  String name;
  String description;
  double progress;
  DateTime deadline;
  int get deadlineMs {
    return deadline.millisecondsSinceEpoch;
  }

  List<String> tags;

  TaskC({
    this.name,
    this.tags,
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
