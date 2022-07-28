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

  HomeBloc(this._reminderRepository) : super(const HomeLoading([])) {
    _reminderRepository.reminders.listen(
      (event) {
        add(DisplayReminders(event));
      },
    );

    on<LoadHomeEvent>(((event, emit) async {
      emit(HomeLoading(event.reminders));
      final List<Reminder> reminders =
          await _reminderRepository.fetchReminders();
      emit(HomeLoaded(reminders));
    }));

    on<DisplayReminders>(
      (event, emit) {
        emit(HomeLoaded(event.reminders));
      },
      transformer: restartable(),
    );

    on<EditReminder>(((event, emit) async {
      await _reminderRepository.editReminder(event.edited);
      // final List<Reminder> reminders =
      //     await _reminderRepository.fetchReminders();
      //emit(HomeLoaded(reminders));
    }));
  }
}
