part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {
  final String? title;
  final String? url;
  final Schedule schedule;
  final Reminder? initialReminder;
  const EditEvent(this.title, this.url, this.schedule, this.initialReminder);

  @override
  List<Object?> get props => [title, url, schedule, initialReminder];
}

/// Update the local reminder details
class UpdateLocalReminderEvent extends EditEvent {
  const UpdateLocalReminderEvent(
      super.title, super.url, super.schedule, super.initialReminder);
}

/// Save reminder to repository
class SaveReminderEvent extends EditEvent {
  const SaveReminderEvent(
      super.title, super.url, super.schedule, super.initialReminder);
}
