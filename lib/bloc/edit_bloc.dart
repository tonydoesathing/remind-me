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
                  minute: DateTime.now().add(const Duration(minutes: 1)).minute,
                  hour: DateTime.now().hour,
                  day: DateTime.now().day,
                  month: DateTime.now().month,
                  year: DateTime.now().year,
                ),
                Reminder(
                    enabled: true,
                    payload: null,
                    type: Reminder.website,
                    schedule: Schedule(
                      repeating: false,
                      minute:
                          DateTime.now().add(const Duration(minutes: 1)).minute,
                      hour: DateTime.now().hour,
                      day: DateTime.now().day,
                      month: DateTime.now().month,
                      year: DateTime.now().year,
                    )))) {
    on<UpdateLocalReminderEvent>((event, emit) {
      _ValidateResults results = _validate(event);
      // make sure title isn't an empty string
      String? title =
          event.title != null && event.title!.isEmpty ? null : event.title;
      if (results.isError) {
        emit(EditSaveFailure(
            title,
            event.payload,
            event.schedule,
            initialReminder,
            EditFailureError(null,
                titleError: results.titleError,
                payloadError: results.payloadError,
                timeError: results.timeError,
                scheduleError: results.scheduleError)));
      } else {
        emit(EditDisplayed(
            title, event.payload, event.schedule, event.initialReminder));
      }
    });

    on<SaveReminderEvent>(
      (event, emit) async {
        emit(EditSaving(
            event.title, event.payload, event.schedule, event.initialReminder));
        // validate input
        _ValidateResults results = _validate(event);

        if (results.isError) {
          emit(EditSaveFailure(
              event.title,
              event.payload,
              event.schedule,
              initialReminder,
              EditFailureError(null,
                  titleError: results.titleError,
                  payloadError: results.payloadError,
                  timeError: results.timeError,
                  scheduleError: results.scheduleError)));
        } else {
          // try and save
          // if initial reminder's id is null, then we're adding a new reminder
          if (event.initialReminder?.id == null) {
            try {
              Reminder addedReminder = await _reminderRepository.addReminder(
                  Reminder(
                      enabled: true,
                      title: event.title,
                      payload: event.payload,
                      type: Reminder.website,
                      schedule: event.schedule));
              emit(EditSaveSuccessful(
                  addedReminder.title,
                  addedReminder.payload,
                  addedReminder.schedule,
                  event.initialReminder,
                  addedReminder));
            } catch (e) {
              emit(EditSaveFailure(event.title, event.payload, event.schedule,
                  event.initialReminder, EditFailureError(e)));
            }
          } else {
            // otherwise, it's an old reminder that must be updated
            try {
              Reminder editedReminder = await _reminderRepository.editReminder(
                  event.initialReminder!.copyWith(
                      title: event.title,
                      payload: event.payload,
                      schedule: event.schedule));
              emit(EditSaveSuccessful(
                  editedReminder.title,
                  editedReminder.payload,
                  editedReminder.schedule,
                  event.initialReminder,
                  editedReminder));
            } catch (e) {
              emit(EditSaveFailure(
                  event.title,
                  event.payload,
                  event.schedule,
                  event.initialReminder,
                  EditFailureError(
                    e,
                  )));
            }
          }
        }
      },
    );
  }

  _ValidateResults _validate(EditEvent event) {
    String? titleError;
    String? payloadError;
    String? timeError;
    String? scheduleError;
    if (event.payload == null || event.payload == "") {
      payloadError = "URL is required";
    } else if (!isURL(event.payload)) {
      payloadError = "URL must be a valid URL";
    }
    if (event.schedule.minute == null || event.schedule.hour == null) {
      timeError = "Time is required";
    } else if (!event.schedule.repeating &&
        DateTime.now().compareTo(DateTime(
                event.schedule.year!,
                event.schedule.month!,
                event.schedule.day!,
                event.schedule.hour!,
                event.schedule.minute!)) >
            -1) {
      timeError = "Time must be in the future";
      scheduleError = "Date must be in the future";
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
