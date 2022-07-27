import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:validators/validators.dart';
part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final ReminderRepository _reminderRepository;

  EditBloc(Reminder? initialReminder, this._reminderRepository)
      : super(initialReminder != null
            ? EditDisplayed(initialReminder.title, initialReminder.payload,
                initialReminder.schedule, initialReminder)
            : EditDisplayed(
                null,
                null,
                Schedule(
                  repeating: false,
                  minute: DateTime.now().minute,
                  hour: DateTime.now().hour,
                  day: DateTime.now().day,
                  month: DateTime.now().month,
                  year: DateTime.now().year,
                ),
                initialReminder)) {
    on<UpdateLocalReminderEvent>((event, emit) {
      _ValidateResults results = _validate(event);

      if (results.isError) {
        emit(EditSaveFailure(
            event.title,
            event.url,
            event.schedule,
            initialReminder,
            EditFailureError(null,
                titleError: results.titleError,
                payloadError: results.payloadError,
                timeError: results.timeError,
                scheduleError: results.scheduleError)));
      } else {
        emit(EditDisplayed(
            event.title, event.url, event.schedule, event.initialReminder));
      }
      // emit(EditDisplayed(
      //     event.title, event.url, event.schedule, event.initialReminder));
    });

    on<SaveReminderEvent>(
      (event, emit) async {
        emit(EditSaving(
            event.title, event.url, event.schedule, event.initialReminder));
        // validate input
        // must have schedule
        if (event.schedule == null) {}
        //

        if (event.schedule != null) {
          // if initial reminder is null, it's a new reminder that must be added
          if (event.initialReminder == null) {
            try {
              Reminder addedReminder = await _reminderRepository.addReminder(
                  Reminder(
                      enabled: true,
                      title: event.title,
                      payload: event.url,
                      type: Reminder.website,
                      schedule: event.schedule));
              emit(EditSaveSuccessful(event.title, event.url, event.schedule,
                  event.initialReminder));
            } catch (e) {
              emit(EditSaveFailure(event.title, event.url, event.schedule,
                  event.initialReminder, EditFailureError(e)));
            }
          } else {
            try {
              Reminder editedReminder = await _reminderRepository.editReminder(
                  Reminder(
                      enabled: true,
                      title: event.title,
                      payload: event.url,
                      type: Reminder.website,
                      schedule: event.schedule));
              emit(EditSaveSuccessful(event.title, event.url, event.schedule,
                  event.initialReminder));
            } catch (e) {
              emit(EditSaveFailure(
                  event.title,
                  event.url,
                  event.schedule,
                  event.initialReminder,
                  EditFailureError(
                    e,
                  )));
            }
          }
        } else {
          emit(EditSaveFailure(event.title, event.url, event.schedule,
              event.initialReminder, EditFailureError(null)));
        }
        // otherwise, it's an old reminder that must be updated
      },
    );
  }

  _ValidateResults _validate(EditEvent event) {
    String? titleError;
    String? payloadError;
    String? timeError;
    String? scheduleError;
    if (event.url == null || event.url == "") {
      payloadError = "URL is required";
    } else if (!isURL(event.url)) {
      payloadError = "URL must be a valid URL";
    }
    if (event.schedule.minute == null || event.schedule.hour == null) {
      timeError = "Time is required";
    }
    return _ValidateResults(
        titleError: titleError,
        payloadError: payloadError,
        timeError: timeError,
        scheduleError: scheduleError);
  }
}

class _ValidateResults {
  final String? titleError;
  final String? payloadError;
  final String? timeError;
  final String? scheduleError;

  _ValidateResults(
      {this.titleError, this.payloadError, this.timeError, this.scheduleError});

  bool get isError {
    return !(titleError == null &&
        payloadError == null &&
        timeError == null &&
        scheduleError == null);
  }
}
