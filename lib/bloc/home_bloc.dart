import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ReminderRepository _reminderRepository;

  HomeBloc(this._reminderRepository) : super(HomeInitial()) {
    on<LoadHomeEvent>(((event, emit) async {
      emit(HomeLoading());
      final List<Reminder> reminders =
          await _reminderRepository.fetchReminders();
      emit(HomeLoaded(reminders));
    }));

    on<AddNewReminder>(
      (event, emit) async {
        if (state is HomeLoaded) {
          final state = this.state as HomeLoaded;
          final rem = Reminder(
              title: Random().nextBool() ? null : "Title",
              enabled: true,
              payload: "payload",
              type: Reminder.website,
              schedule: Schedule(minute: 0, hour: 0, repeating: true));
          final reminder = await _reminderRepository.addReminder(rem);
          emit(HomeLoaded(List.from(state.reminders)..add(reminder)));
        }
      },
    );

    on<EditReminder>(((event, emit) async {
      await _reminderRepository.editReminder(event.edited);
      final List<Reminder> reminders =
          await _reminderRepository.fetchReminders();
      emit(HomeLoaded(reminders));
    }));
  }
}
