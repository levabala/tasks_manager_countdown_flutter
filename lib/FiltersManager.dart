import 'dart:convert';
import 'package:tasks_manager_countdown_flutter/Filter.dart';

class _FiltersManager {
  Map<String, Filter> filters = {};

  void setFilter(String id, Filter f) {
    filters[id] = f;
  }

  void removeFilter(String id) {
    filters.remove(id);
  }

  void loadJSONData(json) {
    var data = jsonDecode(json);
    for (var name in data.keys) {
      filters[name] = data[name];
    }
  }

  String toJSON() {
    Map<String, String> data = {};
    for (var name in filters.keys) {
      data[name] = filters[name].toJSON();
    }
    var json = jsonEncode(data);
    return json;
  }
}

_FiltersManager filtersManager = _FiltersManager();
