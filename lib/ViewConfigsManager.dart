import 'package:todo_countdown/TasksViewConfig.dart';

class _ViewConfigsManager {
  Map<String, TasksViewConfig> configs = {};

  setConfig(name, config) {
    configs[name] = config;
  }

  updateConfig(name, newConfig) {
    configs[name].update(newConfig);
  }
}

_ViewConfigsManager viewConfigsManager = _ViewConfigsManager();
