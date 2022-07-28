import 'package:mocktail/mocktail.dart';
import 'package:remind_me/bloc/home_bloc.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/local_reminder_repository.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

/// I do not know how to properly write Stream tests in Dart.
void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late ReminderRepository repository;

    setUp(() {
      repository = LocalReminderRepository();
      homeBloc = HomeBloc(repository);
    });

    blocTest(
      'homeBloc listens for changes to repository and updates',
      build: () => homeBloc,
      act: (HomeBloc bloc) {
        repository.addReminder(const Reminder(
            enabled: true,
            payload: "payload",
            type: Reminder.website,
            schedule: Schedule(minute: 0, hour: 0, repeating: true)));
      },
      wait: const Duration(seconds: 2),
      expect: () => [isA<HomeLoaded>()],
    );

    blocTest(
      'when request for load home, bloc gives loading and then loaded',
      build: () => homeBloc,
      act: (HomeBloc bloc) {
        bloc.add(const LoadHomeEvent([]));
      },
      wait: const Duration(seconds: 2),
      expect: () => [isA<HomeLoading>(), isA<HomeLoaded>()],
    );
    blocTest(
      'when editing a reminder, homebloc receives new updated list of reminders',
      build: () => homeBloc,
      act: (HomeBloc bloc) async {
        Reminder reminder = await repository.addReminder(const Reminder(
            enabled: true,
            payload: "payload",
            type: Reminder.website,
            schedule: Schedule(minute: 0, hour: 0, repeating: true)));
        await Future.delayed(const Duration(seconds: 1));
        bloc.add(EditReminder(reminder.copyWith(enabled: false), [reminder]));
      },
      wait: const Duration(seconds: 3),
      expect: () => [isA<HomeLoaded>(), isA<HomeLoaded>()],
    );
  });
}
