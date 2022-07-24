import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final ReminderRepository _reminderRepository;

  EditBloc(Reminder? initialReminder, this._reminderRepository)
      : super(EditDisplayed(
            initialReminder ??
                Reminder(
                    enabled: true,
                    payload: "",
                    type: Reminder.website,
                    schedule: Schedule(
                      repeating: false,
                      minute: DateTime.now().minute,
                      hour: DateTime.now().hour,
                      day: DateTime.now().day,
                      month: DateTime.now().month,
                      year: DateTime.now().year,
                    )),
            initialReminder)) {
    on<UpdateLocalReminderEvent>((event, emit) {
      emit(EditDisplayed(event.reminder, event.initialReminder));
    });

    on<SaveReminderEvent>(
      (event, emit) async {
        emit(EditSaving(event.reminder, event.initialReminder));
        // if the reminder doesn't have ID, it's a new reminder that must be added
        if (event.reminder.id == null) {
          try {
            Reminder addedReminder =
                await _reminderRepository.addReminder(event.reminder);
            emit(EditSaveSuccessful(addedReminder, event.initialReminder));
          } catch (e) {
            emit(EditSaveFailure(event.reminder, event.initialReminder, e));
          }
        } else {
          try {
            Reminder editedReminder =
                await _reminderRepository.editReminder(event.reminder);
            emit(EditSaveSuccessful(editedReminder, event.initialReminder));
          } catch (e) {
            emit(EditSaveFailure(event.reminder, event.initialReminder, e));
          }
        }
        // otherwise, it's an old reminder that must be updated
      },
    );
  }
}
