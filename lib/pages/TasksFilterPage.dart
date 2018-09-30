import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:tasks_manager_countdown_flutter/Filter.dart';
import 'package:tasks_manager_countdown_flutter/FiltersManager.dart'
    show filtersManager;
import 'package:tasks_manager_countdown_flutter/Range.dart';
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

  void updateFilter() {
    Filter f = new Filter(
      range: RangeDynamic(
        fromGetter: () => 0,
        toGetter: () => DateTime.now().millisecondsSinceEpoch + timeDeltaMs,
      ),
    );
    filtersManager.setFilter("filter1", f);
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
                data: SliderTheme.of(context).copyWith(
                    valueIndicatorShape: PaddleSliderValueIndicatorShape()),
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

                      updateFilter();
                    });
                  },
                ),
              ),
              Text("Max delta from now displayed: $timeDeltaStr"),
            ],
          ),
        ),
      ),
    );
  }
}

class RangeSliderSample extends StatefulWidget {
  @override
  _RangeSliderSampleState createState() => _RangeSliderSampleState();
}

class _RangeSliderSampleState extends State<RangeSliderSample> {
  double _lowerValue = 20.0;
  double _upperValue = 80.0;

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Scaffold(
        appBar: new AppBar(title: new Text('RangeSlider Demo')),
        body: new Container(
          padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
          child: new Column(
              children: <Widget>[]..add(
                  new RangeSlider(
                    min: 0.0,
                    max: 100.0,
                    lowerValue: _lowerValue,
                    upperValue: _upperValue,
                    divisions: 5,
                    showValueIndicator: true,
                    valueIndicatorMaxDecimals: 1,
                    onChanged: (double newLowerValue, double newUpperValue) {
                      setState(() {
                        _lowerValue = newLowerValue;
                        _upperValue = newUpperValue;
                      });
                    },
                    onChangeStart:
                        (double startLowerValue, double startUpperValue) {
                      print(
                          'Started with values: $startLowerValue and $startUpperValue');
                    },
                    onChangeEnd: (double newLowerValue, double newUpperValue) {
                      print(
                          'Ended with values: $newLowerValue and $newUpperValue');
                    },
                  ),
                )),
        ),
      ),
    );
  }
}
