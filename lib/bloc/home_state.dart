part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {}

/// Show loading
class HomeLoading extends HomeState {}

/// Loaded state
class HomeLoaded extends HomeState {
  final List<Reminder> reminders;

  const HomeLoaded(this.reminders);

  @override
  List<Object> get props => [reminders];
}
