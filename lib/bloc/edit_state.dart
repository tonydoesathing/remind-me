part of 'edit_bloc.dart';

abstract class EditState extends Equatable {
  final String? title;
  final dynamic payload;
  final Schedule schedule;
  final Reminder? initialReminder;

  const EditState(
      this.title, this.payload, this.schedule, this.initialReminder);

  @override
  List<Object?> get props => [title, payload, schedule, initialReminder];
}

/// Displaying the reminder
class EditDisplayed extends EditState {
  const EditDisplayed(
      super.title, super.payload, super.schedule, super.initialReminder);
}

/// When saving
class EditSaving extends EditState {
  const EditSaving(
      super.title, super.payload, super.schedule, super.initialReminder);
}

/// When save succeeds
class EditSaveSuccessful extends EditState {
  final Reminder savedReminder;

  const EditSaveSuccessful(super.title, super.payload, super.schedule,
      super.initialReminder, this.savedReminder);

  @override
  List<Object?> get props => [...super.props, savedReminder];
}

/// When save fails
class EditSaveFailure extends EditState {
  final EditFailureError error;
  const EditSaveFailure(super.title, super.payload, super.schedule,
      super.initialReminder, this.error);

  @override
  List<Object?> get props => [...super.props, error];
}

/// Holds error information and the error messages to display
class EditFailureError extends Equatable {
  final Object? error;
  final String? titleError;
  final String? payloadError;
  final String? timeError;
  final String? scheduleError;

  const EditFailureError(this.error,
      {this.titleError, this.payloadError, this.timeError, this.scheduleError});

  @override
  List<Object?> get props =>
      [error, titleError, payloadError, timeError, scheduleError];
}
