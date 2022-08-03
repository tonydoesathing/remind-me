import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/local_reminder_repository.dart';
import 'package:test/test.dart';

void main() {
  group("LocalReminderRepository >", () {
    test('Initial fetch returns empty list', () async {
      LocalReminderRepository repo = LocalReminderRepository();
      List<Reminder> reminders = await repo.fetchReminders();
      expect(reminders, equals([]));
    });

    test('Adding reminder adds reminder to repository and assigns an ID',
        () async {
      LocalReminderRepository repo = LocalReminderRepository();
      Reminder initial = const Reminder(
          enabled: true,
          payload: "payload",
          type: Reminder.website,
          schedule: Schedule(minute: 0, hour: 0, repeating: true));
      Reminder reminder = await repo.addReminder(initial);
      expect(reminder, equals(initial.copyWith(id: 1)));

      List<Reminder> reminders = await repo.fetchReminders();
      expect(reminders, equals([reminder]));
    });

    test('Can fetch reminder from ID', () async {
      LocalReminderRepository repo = LocalReminderRepository();
      Reminder initial = const Reminder(
          enabled: true,
          payload: "payload",
          type: Reminder.website,
          schedule: Schedule(minute: 0, hour: 0, repeating: true));
      Reminder reminder = await repo.addReminder(initial);
      expect(reminder, equals(initial.copyWith(id: 1)));

      Reminder fetched = await repo.fetchReminder(reminder.id ?? 0);
      expect(fetched, equals(reminder));
    });

    test('Can remove reminder from repository', () async {
      LocalReminderRepository repo = LocalReminderRepository();
      Reminder initial = const Reminder(
          enabled: true,
          payload: "payload",
          type: Reminder.website,
          schedule: Schedule(minute: 0, hour: 0, repeating: true));
      Reminder reminder = await repo.addReminder(initial);
      expect(reminder, equals(initial.copyWith(id: 1)));

      Reminder removed = await repo.removeReminder(reminder);
      expect(removed, equals(reminder));

      List<Reminder> reminders = await repo.fetchReminders();
      expect(reminders, equals([]));
    });

    test('Can edit a reminder', () async {
      LocalReminderRepository repo = LocalReminderRepository();
      Reminder initial = const Reminder(
          enabled: true,
          payload: "payload",
          type: Reminder.website,
          schedule: Schedule(minute: 0, hour: 0, repeating: true));
      Reminder reminder = await repo.addReminder(initial);
      expect(reminder, equals(initial.copyWith(id: 1)));

      Reminder edit = reminder.copyWith(enabled: false);
      Reminder edited = await repo.editReminder(edit);

      expect(edited, equals(edit));

      Reminder fetched = await repo.fetchReminder(edited.id ?? 0);
      expect(fetched, equals(edited));
    });

    // test('Updates stream on add', () async {
    //   LocalReminderRepository repo = LocalReminderRepository();
    //   Reminder initial = const Reminder(
    //       enabled: true,
    //       payload: "payload",
    //       type: Reminder.website,
    //       schedule: Schedule(minute: 0, hour: 0, repeating: true));
    //   Reminder reminder = await repo.addReminder(initial);
    //   expect(repo.reminders, emits([reminder]));
    //   // expect(reminder, equals(initial.copyWith(id: 1)));

    //   // Reminder edit = reminder.copyWith(enabled: false);
    //   // Reminder edited = await repo.editReminder(edit);

    //   // expect(edited, equals(edit));

    //   // Reminder fetched = await repo.fetchReminder(edited.id ?? 0);
    //   // expect(fetched, equals(edited));
    // });

    // test('Updates stream on edit', () async {
    //   LocalReminderRepository repo = LocalReminderRepository();
    //   Reminder initial = const Reminder(
    //       enabled: true,
    //       payload: "payload",
    //       type: Reminder.website,
    //       schedule: Schedule(minute: 0, hour: 0, repeating: true));

    //   repo.reminders.listen(expectAsync1<void, List<Reminder>>((reminders) {
    //     expect(reminders, [initial.copyWith(id: 1)]);
    //   }, max: 1));
    //   Reminder reminder = await repo.addReminder(initial);
    //   repo.reminders.listen(expectAsync1<void, List<Reminder>>((reminders) {
    //     expect(reminders, [initial.copyWith(id: 1, enabled: false)]);
    //   }, max: 1));
    //   Reminder edit = reminder.copyWith(enabled: false);
    //   Reminder edited = await repo.editReminder(edit);
    // });
  });
}
