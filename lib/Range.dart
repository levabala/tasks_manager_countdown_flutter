import 'dart:convert';

import 'package:flutter/foundation.dart';

class Range {
  final int _from, _to;

  int get from {
    return _from;
  }

  int get to {
    return _to;
  }

  const Range(this._from, this._to);

  bool isIn({
    @required int value,
    bool includeLeft = true,
    bool inculdeRight = true,
  }) {
    return (includeLeft && value >= from || !inculdeRight && value > from) &&
        (inculdeRight && value <= to || !inculdeRight && value < to);
  }

  static const Range ZERO_TO_ZERO = const Range(0, 0);

  String toJSON() {
    Map<String, int> data = {
      "from": _from,
      "to": _to,
    };
    var json = jsonEncode(data);
    return json;
  }

  static Range fromJSON(json) {
    var data = jsonDecode(json);
    return Range(data["from"], data["to"]);
  }
}

typedef int GetInt();

class RangeDynamic extends Range {
  GetInt fromGetter, toGetter;
  int get from {
    return fromGetter();
  }

  int get to {
    return toGetter();
  }

  RangeDynamic({@required this.fromGetter, @required this.toGetter})
      : super(fromGetter(), toGetter());
}
