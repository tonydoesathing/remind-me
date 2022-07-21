import '../models/schedule.dart';

/// A helper class to parse a [Schedule] properly
class ScheduleUtils {
  static final ScheduleUtils _scheduleParser = ScheduleUtils._();

  factory ScheduleUtils() {
    return _scheduleParser;
  }

  ScheduleUtils._() {}

  /// Takes a day int and returns its name in String form
  String dayToString(int day) {
    switch (day) {
      case DateTime.monday:
        return "Monday";

      case DateTime.tuesday:
        return "Tuesday";

      case DateTime.wednesday:
        return "Wednesday";

      case DateTime.thursday:
        return "Thursday";

      case DateTime.friday:
        return "Friday";

      case DateTime.saturday:
        return "Saturday";

      case DateTime.sunday:
        return "Sunday";
    }

    return "IMPROPER DAY INT";
  }

  /// Takes a day int and returns its name in String form
  String monthToString(int month) {
    switch (month) {
      case DateTime.january:
        return "January";

      case DateTime.february:
        return "February";

      case DateTime.march:
        return "March";

      case DateTime.april:
        return "April";

      case DateTime.may:
        return "May";

      case DateTime.june:
        return "June";

      case DateTime.july:
        return "July";

      case DateTime.august:
        return "August";

      case DateTime.september:
        return "September";

      case DateTime.october:
        return "October";

      case DateTime.november:
        return "November";

      case DateTime.december:
        return "December";
    }

    return "IMPROPER MONTH INT";
  }

  /// Return a human-readable representation of the schedule
  String parseSchedule(Schedule schedule, String timezone) {
    // if not repeating, return the date
    if (schedule.repeating) {
      return "";
    }
    return "";
  }
}
