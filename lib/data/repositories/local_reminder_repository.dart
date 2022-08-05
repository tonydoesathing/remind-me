import 'dart:async';

import '../models/reminder.dart';
import 'reminder_repository.dart';

/// Implements [ReminderRepository] in local memory
class LocalReminderRepository extends ReminderRepository {
  final StreamController<List<Reminder>> _streamController =
      StreamController<List<Reminder>>.broadcast();
  List<Reminder> _reminders = [];

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    Reminder newReminder =
        reminder.copyWith(id: reminder.id ?? _reminders.length + 1);
    _reminders.add(newReminder);
    _streamController.add(List<Reminder>.of(_reminders));
    return newReminder;
  }

  @override
  Stream<List<Reminder>> get reminders {
    return _streamController.stream;
  }

  @override
  Future<Reminder> editReminder(Reminder reminder) async {
    int index = _reminders.indexWhere((element) => element.id == reminder.id);

    if (index > -1) {
      _reminders.removeAt(index);
      _reminders.insert(index, reminder);

      _streamController.add(List<Reminder>.of(_reminders));
      return reminder;
    }
    throw ReminderNotFound();
  }

  @override
  Future<Reminder> removeReminder(Reminder reminder) async {
    int index = _reminders.indexWhere((rem) => rem.id == reminder.id);

    if (index > -1) {
      _reminders.removeAt(index);

      _streamController.add(List<Reminder>.of(_reminders));
      return reminder;
    }
    throw Exception("could not find reminder of id $reminder.id");
  }

  @override
  Future<Reminder> fetchReminder(int id) async {
    int index = _reminders.indexWhere((reminder) => reminder.id == id);

    if (index > -1) {
      return _reminders[index];
    }
    throw Exception("could not find requested id of $id");
  }

  @override
  Future<List<Reminder>> fetchReminders() async {
    _streamController.add(List<Reminder>.of(_reminders));
    return List<Reminder>.of(_reminders);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
