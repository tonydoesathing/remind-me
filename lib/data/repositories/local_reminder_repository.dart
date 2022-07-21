import '../models/reminder.dart';
import 'reminder_repository.dart';

/// Implements [ReminderRepository] in local memory
class LocalReminderRepository extends ReminderRepository {
  List<Reminder> reminders = [];

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    Reminder newReminder = reminder.copyWith(id: reminders.length + 1);
    reminders.add(newReminder);

    return newReminder;
  }

  @override
  Future<Reminder> editReminder(Reminder reminder) async {
    int index = reminders.indexWhere((element) => element.id == reminder.id);

    if (index > -1) {
      reminders.removeAt(index);
      reminders.insert(index, reminder);

      return reminder;
    }
    throw ReminderNotFound();
  }

  @override
  Future<Reminder> removeReminder(Reminder reminder) async {
    int index = reminders.indexWhere((rem) => rem.id == reminder.id);

    if (index > -1) {
      reminders.removeAt(index);
      return reminder;
    }
    throw Exception("could not find reminder of id $reminder.id");
  }

  @override
  Future<Reminder> fetchReminder(int id) async {
    int index = reminders.indexWhere((reminder) => reminder.id == id);

    if (index > -1) {
      return reminders[index];
    }
    throw Exception("could not find requested id of $id");
  }

  @override
  Future<List<Reminder>> fetchReminders() async {
    return List<Reminder>.of(reminders);
  }
}
