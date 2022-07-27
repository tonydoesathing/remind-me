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

  /// Takes a day string and returns its name in int form
  int stringToDay(String day) {
    switch (day) {
      case "Monday":
        return DateTime.monday;

      case "Tuesday":
        return DateTime.tuesday;

      case "Wednesday":
        return DateTime.wednesday;

      case "Thursday":
        return DateTime.thursday;

      case "Friday":
        return DateTime.friday;

      case "Saturday":
        return DateTime.saturday;

      case "Sunday":
        return DateTime.sunday;
    }

    return -1;
  }

  /// Takes a month int and returns its name in String form
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

  /// Takes a month string and returns its int form
  int stringToMonth(String month) {
    switch (month) {
      case "January":
        return DateTime.january;

      case "February":
        return DateTime.february;

      case "March":
        return DateTime.march;

      case "April":
        return DateTime.april;

      case "May":
        return DateTime.may;

      case "June":
        return DateTime.june;

      case "July":
        return DateTime.july;

      case "August":
        return DateTime.august;

      case "September":
        return DateTime.september;

      case "October":
        return DateTime.october;

      case "November":
        return DateTime.november;

      case "December":
        return DateTime.december;
    }

    return -1;
  }

  /// Takes a day of the month and returns its string form
  String dayToQualifierString(int day) {
    // state.schedule.day! % 10 == 1 ? "st" : state.schedule.day! % 10 == 2 ? "nd" : state.schedule.day! % 10 == 3 ? "rd" : "th"
    if (day < 10 || day > 19) {
      if (day % 10 == 1) {
        return "${day}st";
      } else if (day % 10 == 2) {
        return "${day}nd";
      } else if (day % 10 == 3) {
        return "${day}rd";
      } else {
        return "${day}th";
      }
    } else {
      return "${day}th";
    }
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
