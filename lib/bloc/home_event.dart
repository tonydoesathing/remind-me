part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  final List<Reminder> reminders;
  const HomeEvent(this.reminders);

  @override
  List<Object> get props => [reminders];
}

/// Loads reminders
class LoadHomeEvent extends HomeEvent {
  const LoadHomeEvent(super.reminders);
}

/// Show reminders
class DisplayReminders extends HomeEvent {
  const DisplayReminders(super.reminders);
}

/// Request to edit a reminder
class EditReminder extends HomeEvent {
  final Reminder edited;

  const EditReminder(this.edited, super.reminders);

  @override
  List<Object> get props => [...super.props, edited];
}
