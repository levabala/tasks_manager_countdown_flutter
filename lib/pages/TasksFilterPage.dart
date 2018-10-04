import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:todo_countdown/classes/Filter.dart';
import 'package:todo_countdown/classes/Range.dart';
import 'package:todo_countdown/managers/AppConfigurator.dart';
import 'package:todo_countdown/managers/FiltersManager.dart';
import 'package:todo_countdown/managers/ViewConfigsManager.dart';
import 'package:todo_countdown/other/StringGenerators.dart';

class FilterTaskPage extends StatefulWidget {
  @override
  FilterTaskPageState createState() {
    return FilterTaskPageState();
  }
}

class FilterTaskPageState extends State<FilterTaskPage> {
  String timeDeltaStr = remainTimeToString(0);
  double _lowerValue = 0.0, _upperValue = 0.3, power = 5.0;
  int timeDeltaMs = 0;
  int maxPossibleMs =
      DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch;
  int get diffNowAndMax {
    return maxPossibleMs - DateTime.now().millisecondsSinceEpoch;
  }

  void updateFilter({bool finalized = true}) {
    Filter filter = new Filter(
      range: RangeDynamic(
        fromGetter: () => viewConfigsManager.configs["main"].showPastTasks
            ? 0
            : DateTime.now().millisecondsSinceEpoch,
        toGetter: () => DateTime.now().millisecondsSinceEpoch + timeDeltaMs,
      ),
    );
    filtersManager.setFilter(
        id: "default", filter: filter, finalized: finalized);
  }

  int getDeltaMs(value) {
    return (pow(value, power) * diffNowAndMax).toInt();
  }

  double getValue(deltaMs) {
    return pow(deltaMs / diffNowAndMax, 1 / power);
  }

  @override
  Widget build(BuildContext context) {
    if (filtersManager.filters.containsKey("default")) {
      var filter = filtersManager.filters["default"];
      timeDeltaMs = filter.range.to - DateTime.now().millisecondsSinceEpoch;
      timeDeltaMs = max(timeDeltaMs, 0);
      var value = getValue(timeDeltaMs);
      _upperValue = max(min(value, 1.0), 0.1);
      timeDeltaStr = remainTimeToString(timeDeltaMs);
    }

    return new SafeArea(
      top: false,
      bottom: false,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Filter tasks"),
        ),
        body: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(),
                    child: RangeSlider(
                      lowerValue: _lowerValue,
                      upperValue: _upperValue,
                      min: 0.0,
                      max: 1.0,
                      showValueIndicator: true,
                      touchRadiusExpansionRatio: 5.0,
                      onChanged: (low, up) {
                        setState(() {
                          //_lowerValue = low;
                          _upperValue = up;
                          timeDeltaMs = getDeltaMs(up);
                          timeDeltaStr = remainTimeToString(timeDeltaMs);

                          updateFilter(finalized: false);
                        });
                      },
                      onChangeEnd: (low, up) {
                        setState(() {
                          _upperValue = up;
                          timeDeltaMs = getDeltaMs(up);
                          timeDeltaStr = remainTimeToString(timeDeltaMs);

                          updateFilter();
                        });
                      },
                    ),
                  ),
                  Text("Max delta from now displayed: $timeDeltaStr"),
                  CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        viewConfigsManager.configs["main"].showPastTasks =
                            value;
                        updateFilter(finalized: true);
                      });
                    },
                    value: viewConfigsManager.configs["main"].showPastTasks,
                    title: Text("Include past tasks"),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  await appConfigurator.clearStorage();
                  appConfigurator.resetManagers();
                  appConfigurator.loadFromStorage();
                },
                child: Text("Clear all data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
