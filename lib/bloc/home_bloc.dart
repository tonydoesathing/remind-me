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

    on<EditReminder>(((event, emit) async {
      await _reminderRepository.editReminder(event.edited);
    }));

    on<ToggleSelectView>(((event, emit) {
      if (event.selected == null) {
        add(DisplayReminders(event.reminders, const []));
      } else {
        add(DisplayReminders(event.reminders, null));
      }
    }));
  }
}
