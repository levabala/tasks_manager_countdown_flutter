import 'package:intl/intl.dart';

// nice string formatter :)
String remainTimeToString(int ms) {
  bool happened = ms <= 0;
  ms = ms.abs();

  int seconds = ms ~/ (1000);
  int minutes = ms ~/ (1000 * 60);
  int hours = ms ~/ (1000 * 60 * 60);
  int days = ms ~/ (1000 * 60 * 60 * 24);
  int monthes = ms ~/ (1000 * 60 * 60 * 24 * 30);
  int years = ms ~/ (1000 * 60 * 60 * 24 * 30 * 12);

  double minutesD = ms / (1000 * 60);
  double hoursD = ms / (1000 * 60 * 60);
  double daysD = ms / (1000 * 60 * 60 * 24);
  double monthesD = ms / (1000 * 60 * 60 * 24 * 30);
  double yearsD = ms / (1000 * 60 * 60 * 24 * 30 * 12);

  String str = "$seconds secs";
  if (years == 1)
    str = "$years year";
  else if (years > 0)
    str = "${yearsD.toStringAsFixed(1)} years";
  else if (monthesD == 1.0)
    str = "$monthes month";
  else if (monthes > 0)
    str = "${monthesD.toStringAsFixed(1)} months";
  else if (daysD == 1.0)
    str = "$days day";
  else if (days > 0)
    str = "${daysD.toStringAsFixed(1)} days";
  else if (hours == 1)
    str = "$hours hour";
  else if (hours > 0)
    str = "${hoursD.toStringAsFixed(1)} hours";
  else if (minutes == 1)
    str = "$minutes min";
  else if (minutes > 0)
    str = "${minutesD.toStringAsFixed(1)} mins";
  else if (seconds == 1) str = "$seconds sec";

  if (happened)
    return "$str ago";
  else
    return "$str";
}

String finishDateToString(DateTime finishDate, int msToFinish) {
  bool happened = msToFinish <= 0;
  msToFinish = msToFinish.abs();

  DateFormat formatter = new DateFormat('dd.MM.yy');
  if (msToFinish < 1000 * 60 * 60 * 24) formatter = new DateFormat('jm');
  if (happened)
    return "was at ${formatter.format(finishDate)}";
  else
    return "to ${formatter.format(finishDate)}";
}
