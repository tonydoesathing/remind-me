import '../models/reminder.dart';

/// Provides access to the [Reminder] storage
abstract class ReminderRepository {
  /// fetches all of the reminders
  Future<List<Reminder>> fetchReminders();

  /// fetches the reminder of [id]
  Future<Reminder> fetchReminder(int id);

  /// adds specified [reminder] to storage, assigning an [id]
  Future<Reminder> addReminder(Reminder reminder);

  /// removes [reminder] from storage
  Future<Reminder> removeReminder(Reminder reminder);

  /// edits [reminder] in storage
  Future<Reminder> editReminder(Reminder reminder);
}

class ReminderNotFound implements Exception {}
