part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Loads reminders
class LoadHomeEvent extends HomeEvent {}

/// Request to add a reminder
class AddNewReminder extends HomeEvent {
  final Reminder? newReminder;

  const AddNewReminder(this.newReminder);

  @override
  List<Object?> get props => [newReminder];
}

/// Request to edit a reminder
class EditReminder extends HomeEvent {
  final Reminder edited;

  const EditReminder(this.edited);

  @override
  List<Object> get props => [edited];
}
