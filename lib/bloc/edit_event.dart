part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {
  final Reminder reminder;
  final Reminder initialReminder;
  const EditEvent(this.reminder, this.initialReminder);

  @override
  List<Object> get props => [];
}

/// Update the local reminder details
class UpdateLocalReminderEvent extends EditEvent {
  const UpdateLocalReminderEvent(super.reminder, super.initialReminder);
}

/// Save reminder to repository
class SaveReminderEvent extends EditEvent {
  const SaveReminderEvent(super.reminder, super.initialReminder);
}
