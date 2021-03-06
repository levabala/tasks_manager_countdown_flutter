import 'dart:convert';
import 'package:todo_countdown/classes/Filter.dart';
import 'package:todo_countdown/managers/AppConfigurator.dart';

class _FiltersManager {
  Map<String, Filter> filters = {
    "default": Filter(),
  };

  void setFilter({String id, Filter filter, bool finalized = true}) {
    filters[id] = filter;
    // the same logic as for _TasksManager
    if (finalized) appConfigurator.writeToStorage();
  }

  void reset() {
    filters.clear();
  }

  void removeFilter(String id) {
    filters.remove(id);
    appConfigurator.writeToStorage();
  }

  void loadJSONData(json) {
    var data = jsonDecode(json);
    for (var name in data.keys) {
      filters[name] = Filter.fromJSON(data[name]);
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
