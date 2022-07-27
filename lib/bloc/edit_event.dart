part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {
  final String? title;
  final dynamic payload;
  final Schedule schedule;
  final Reminder? initialReminder;
  const EditEvent(
      this.title, this.payload, this.schedule, this.initialReminder);

  @override
  List<Object?> get props => [title, payload, schedule, initialReminder];
}

/// Update the local reminder details
class UpdateLocalReminderEvent extends EditEvent {
  const UpdateLocalReminderEvent(
      super.title, super.payload, super.schedule, super.initialReminder);
}

/// Save reminder to repository
class SaveReminderEvent extends EditEvent {
  const SaveReminderEvent(
      super.title, super.payload, super.schedule, super.initialReminder);
}
