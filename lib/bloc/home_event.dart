part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  final List<Reminder> reminders;
  final List<Reminder>? selected;

  const HomeEvent(this.reminders, this.selected);

  @override
  List<Object?> get props => [reminders, selected];
}

/// Loads reminders
class LoadHomeEvent extends HomeEvent {
  const LoadHomeEvent(super.reminders, super.selected);
}

/// Show reminders
class DisplayReminders extends HomeEvent {
  const DisplayReminders(super.reminders, super.selected);
}

/// Request to edit a reminder
class ToggleReminderEnabled extends HomeEvent {
  final Reminder edited;

  const ToggleReminderEnabled(this.edited, super.reminders, super.selected);

  @override
  List<Object?> get props => [...super.props, edited];
}

/// Toggle select view
class ToggleSelectView extends HomeEvent {
  final Reminder? reminder;
  const ToggleSelectView(super.reminders, super.selected, {this.reminder});

  @override
  List<Object?> get props => [...super.props, reminder];
}

/// Toggle select reminder
class ToggleSelectReminder extends HomeEvent {
  final Reminder reminder;

  const ToggleSelectReminder(this.reminder, super.reminders, super.selected);

  @override
  List<Object?> get props => [...super.props, reminder];
}

class ToggleSelectAllReminders extends HomeEvent {
  const ToggleSelectAllReminders(super.reminders, super.selected);
}

/// Remove selected reminders
class RemoveSelectedReminders extends HomeEvent {
  const RemoveSelectedReminders(super.reminders, super.selected);
}

/// Toggles selected reminders to all be [on]
class ToggleSelectedReminders extends HomeEvent {
  final bool on;
  const ToggleSelectedReminders(super.reminders, super.selected, this.on);

  @override
  List<Object?> get props => [...super.props, on];
}
