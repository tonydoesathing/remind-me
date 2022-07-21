// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron_parser/cron_parser.dart';
import 'package:equatable/equatable.dart';

/// Stores a day/time or a repetition cycle
/// Can repeat every day at a certain time,
/// every week on certain days at a certain time,
/// every month on certain days at a certain time
class Schedule extends Equatable {
  /// The minute 0-59 in an hour
  final int? minute;

  /// The hour 0-23 in a day
  final int? hour;

  /// The day of the month 1-31
  final int? day;

  /// The day of the week 1-7 as from the [DateTime] class
  final int? weekday;

  /// Month 1-12 in a year as from the [DateTime] class
  final int? month;

  /// Year to set
  final int? year;

  /// Whether it should repeat or be a single use
  final bool repeating;

  /// Create a [Schedule] from Miliseconds between 00:00 and 24:00, day of the week, and repetition cycle
  const Schedule({
    required this.repeating,
    this.minute,
    this.hour,
    this.day,
    this.weekday,
    this.month,
    this.year,
  })  : assert(
            minute != null ||
                hour != null ||
                day != null ||
                weekday != null ||
                month != null ||
                year != null,
            'At least one time parameter must not be null'),
        assert(
            repeating == true ||
                repeating == false &&
                    minute != null &&
                    hour != null &&
                    day != null &&
                    month != null &&
                    year != null,
            'If not repeating, must provide full date fields'),
        assert(minute == null || (minute >= 0 && minute < 60),
            'Minutes must be between 0-59'),
        assert(hour == null || (hour >= 0 && hour < 23),
            'Hours must be between 0-23'),
        assert(
            day == null || (day > 0 && day < 32), 'Days must be between 1-31'),
        assert(
            weekday == null ||
                (weekday >= DateTime.monday && weekday <= DateTime.sunday),
            'Weekdays must be between ${DateTime.monday}-${DateTime.sunday}'),
        assert(
            month == null ||
                (month >= DateTime.january && month <= DateTime.december),
            'Months must be between ${DateTime.january}-${DateTime.december}'),
        assert(
            repeating == false ||
                repeating == true && minute != null && hour != null ||
                repeating == true &&
                    minute != null &&
                    hour != null &&
                    weekday != null ||
                repeating == true &&
                    minute != null &&
                    hour != null &&
                    day != null,
            'If repeating daily, weekly, monthly, must provide proper times');

  Schedule copyWith({
    int? minute,
    int? hour,
    int? day,
    int? weekday,
    int? month,
    int? year,
    bool? repeating,
  }) {
    return Schedule(
      repeating: repeating ?? this.repeating,
      minute: minute ?? this.minute,
      hour: hour ?? this.hour,
      day: day ?? this.day,
      weekday: weekday ?? this.weekday,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minute': minute,
      'hour': hour,
      'day': day,
      'weekday': weekday,
      'month': month,
      'year': year,
      'repeating': repeating,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      repeating: map['repeating'] as bool,
      minute: map['minute'] != null ? map['minute'] as int : null,
      hour: map['hour'] != null ? map['hour'] as int : null,
      day: map['day'] != null ? map['day'] as int : null,
      weekday: map['weekday'] != null ? map['weekday'] as int : null,
      month: map['month'] != null ? map['month'] as int : null,
      year: ['year'] != null ? map['year'] as int : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      minute,
      hour,
      day,
      weekday,
      month,
      year,
      repeating,
    ];
  }

  @override
  String toString() {
    // var cronIterator = Cron().parse("0 * * * *", "Etc/UTC");
    // return cronIterator.next().toString();
    return super.toString();
  }
}

// /// Takes a [time] in milliseconds after 00:00 and converts it to a String representing clock time
// String timeToDayTime(int time, {bool militaryTime = true}) {
//   int hours = time % 3600000;
//   int minutes = time % 60000;

//   String minsString = minutes < 10 ? '0$minutes' : '$minutes';

//   return militaryTime
//       ? '$hours:$minutes'
//       : '${hours % 12}:$minsString : $minsString}';
// }
