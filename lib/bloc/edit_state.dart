part of 'edit_bloc.dart';

abstract class EditState extends Equatable {
  final Reminder reminder;
  final Reminder? initialReminder;

  const EditState(this.reminder, this.initialReminder);

  @override
  List<Object?> get props => [reminder, initialReminder];
}

/// Displaying the reminder
class EditDisplayed extends EditState {
  const EditDisplayed(super.reminder, super.initialReminder);
}

/// When saving
class EditSaving extends EditState {
  const EditSaving(super.reminder, super.initialReminder);
}

/// When save succeeds
class EditSaveSuccessful extends EditState {
  const EditSaveSuccessful(super.reminder, super.initialReminder);
}

/// When save fails
class EditSaveFailure extends EditState {
  final Object error;
  const EditSaveFailure(super.reminder, super.initialReminder, this.error);

  @override
  List<Object?> get props => [...super.props, error];
}
