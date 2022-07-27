import 'package:equatable/equatable.dart';

import 'package:remind_me/data/models/schedule.dart';

/// An [Reminder] holds the [schedule] information, whether or not it's [enabled], and the [payload] to go to
class Reminder extends Equatable {
  /// Website type
  static const int website = 1;

  /// The name of the reminder; can be null
  final String? title;

  /// Whether or not the reminder is [enabled]
  final bool enabled;

  /// Additional data to perform the action
  final dynamic payload;

  /// What kind of reminder it is
  final int type;

  /// Which reminder it is
  final int? id;

  /// On what [schedule] the reminder runs on
  final Schedule schedule;
  const Reminder({
    this.title,
    required this.enabled,
    required this.payload,
    required this.type,
    this.id,
    required this.schedule,
  });

  @override
  List<Object?> get props {
    return [
      title,
      enabled,
      payload,
      type,
      id,
      schedule,
    ];
  }

  Reminder copyWith({
    String? title,
    bool? enabled,
    dynamic? payload,
    int? type,
    int? id,
    Schedule? schedule,
  }) {
    return Reminder(
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      payload: payload ?? this.payload,
      type: type ?? this.type,
      id: id ?? this.id,
      schedule: schedule ?? this.schedule,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'enabled': enabled,
      'payload': payload,
      'type': type,
      'id': id,
      'schedule': schedule.toMap(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      title: map['title'] != null ? map['title'] as String : null,
      enabled: map['enabled'] as bool,
      payload: map['payload'] as dynamic,
      type: map['type'] as int,
      id: map['id'] != null ? map['id'] as int : null,
      schedule: Schedule.fromMap(map['schedule'] as Map<String, dynamic>),
    );
  }
}
