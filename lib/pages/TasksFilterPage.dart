import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:tasks_manager_countdown_flutter/Filter.dart';
import 'package:tasks_manager_countdown_flutter/Range.dart';
import 'package:tasks_manager_countdown_flutter/FiltersManager.dart'
    show filtersManager;
import 'package:tasks_manager_countdown_flutter/ViewConfigsManager.dart'
    show viewConfigsManager;
import '../StringGenerators.dart' show remainTimeToString;
import 'dart:math';

class FilterTaskPage extends StatefulWidget {
  @override
  FilterTaskPageState createState() {
    return FilterTaskPageState();
  }
}

class FilterTaskPageState extends State<FilterTaskPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _lowerValue = 0.0, _upperValue = 0.3, power = 5.0;
  int timeDeltaMs = 0;
  String timeDeltaStr = remainTimeToString(0);
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
        id: "filter1", filter: filter, finalized: finalized);
  }

  int getDeltaMs(value) {
    return (pow(value, power) * diffNowAndMax).toInt();
  }

  double getValue(deltaMs) {
    return pow(deltaMs / diffNowAndMax, 1 / power);
  }

  @override
  Widget build(BuildContext context) {
    if (filtersManager.filters.containsKey("filter1")) {
      var filter = filtersManager.filters["filter1"];
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
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Filter tasks"),
        ),
        body: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Column(
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
                    viewConfigsManager.configs["main"].showPastTasks = value;
                    updateFilter(finalized: true);
                  });
                },
                value: viewConfigsManager.configs["main"].showPastTasks,
                title: Text("Include past tasks"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
