import 'dart:async';

import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/providers/sembast_provider.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:sembast/sembast.dart';

class PersistedReminderRepository extends ReminderRepository {
  final StreamController<List<Reminder>> _streamController =
      StreamController<List<Reminder>>.broadcast();

  final _reminderStore = intMapStoreFactory.store("reminders");

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    final id = await _reminderStore.add(
        await SembastProvider().database, reminder.toMap());
    List<Reminder> reminders = await fetchReminders();
    _streamController.add(reminders);
    return reminder.copyWith(id: id);
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Future<Reminder> editReminder(Reminder reminder) async {
    final finder = Finder(filter: Filter.byKey(reminder.id));
    final numUpdated = await _reminderStore.update(
        await SembastProvider().database, reminder.toMap(),
        finder: finder);

    if (numUpdated < 1) {
      throw ReminderNotFound();
    }
    List<Reminder> reminders = await fetchReminders();
    _streamController.add(reminders);
    return reminder;
  }

  @override
  Future<Reminder> fetchReminder(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    final records = await _reminderStore.find(await SembastProvider().database,
        finder: finder);
    return records
        .map((record) {
          Map<String, dynamic> reminderRecord = Map.from(record.value);
          reminderRecord["id"] = record.key;

          return Reminder.fromMap(reminderRecord);
        })
        .toList()
        .first;
  }

  @override
  Future<List<Reminder>> fetchReminders() async {
    final finder = Finder(sortOrders: [SortOrder(Field.key)]);
    final records = await _reminderStore.find(await SembastProvider().database,
        finder: finder);
    return records.map((record) {
      Map<String, dynamic> reminderRecord = Map.from(record.value);
      reminderRecord["id"] = record.key;

      return Reminder.fromMap(reminderRecord);
    }).toList();
  }

  @override
  Stream<List<Reminder>> get reminders => _streamController.stream;

  @override
  Future<Reminder> removeReminder(Reminder reminder) async {
    final finder = Finder(filter: Filter.byKey(reminder.id));
    final numDeleted = await _reminderStore
        .delete(await SembastProvider().database, finder: finder);

    if (numDeleted < 1) {
      throw ReminderNotFound();
    }
    List<Reminder> reminders = await fetchReminders();
    _streamController.add(reminders);
    return reminder;
  }
}
