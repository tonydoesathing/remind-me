import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ReminderRepository _reminderRepository;

  HomeBloc(this._reminderRepository) : super(const HomeLoading([], null)) {
    // _reminderRepository.reminders.listen(
    //   (event) {
    //     add(DisplayReminders(event, null));
    //   },
    // );

    on<LoadHomeEvent>(((event, emit) async {
      emit(HomeLoading(event.reminders, event.selected));
      final List<Reminder> reminders =
          await _reminderRepository.fetchReminders();
      add(DisplayReminders(reminders, event.selected));
      //emit(HomeLoaded(reminders, event.selected));
    }));

    on<DisplayReminders>(
      (event, emit) async {
        emit(HomeLoaded(event.reminders, event.selected));
        await emit.forEach(_reminderRepository.reminders,
            onData: (List<Reminder> data) {
          return HomeLoaded(data, event.selected);
        });
      },
      transformer: restartable(),
    );

    on<ToggleReminderEnabled>(((event, emit) async {
      await _reminderRepository.editReminder(event.edited);
    }));

    on<ToggleSelectView>(((event, emit) {
      if (event.selected == null) {
        add(DisplayReminders(
            event.reminders, event.reminder != null ? [event.reminder!] : []));
      } else {
        add(DisplayReminders(event.reminders, null));
      }
    }));

    on<ToggleSelectAllReminders>(
      (event, emit) {
        if (event.selected == event.reminders) {
          add(DisplayReminders(event.reminders, const []));
        } else {
          add(DisplayReminders(event.reminders, event.reminders));
        }
      },
    );

    on<ToggleSelectReminder>(((event, emit) {
      if (event.selected != null && event.selected!.contains(event.reminder)) {
        final int index = event.selected!.indexOf(event.reminder);
        if (index < event.selected!.length - 1) {
          add(DisplayReminders(
              event.reminders,
              event.selected!.sublist(0, index) +
                  event.selected!.sublist(index + 1)));
        } else {
          add(DisplayReminders(
              event.reminders, event.selected!.sublist(0, index)));
        }
      } else if (event.selected != null) {
        add(DisplayReminders(
            event.reminders, event.selected! + [event.reminder]));
      }
    }));

    on<ToggleSelectedReminders>(((event, emit) async {
      List<Reminder> reminders = List.from(event.reminders);
      // edit the reminders
      for (Reminder reminder in event.selected!) {
        Reminder edited = await _reminderRepository
            .editReminder(reminder.copyWith(enabled: event.on));
        // edit the reminders locally
        int index = event.reminders.indexOf(reminder);
        reminders[index] = edited;
      }
      add(DisplayReminders(reminders, null));
    }));

    on<RemoveSelectedReminders>(
      (event, emit) async {
        List<Reminder> reminders = List.from(event.reminders);
        // remove the reminders
        for (Reminder reminder in event.selected!) {
          await _reminderRepository.removeReminder(reminder);
          // remove the reminders locally

          reminders.remove(reminder);
        }
        add(DisplayReminders(reminders, null));
      },
    );
  }
}
