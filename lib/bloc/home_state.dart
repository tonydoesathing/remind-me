part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<Reminder> reminders;
  const HomeState(this.reminders);

  @override
  List<Object> get props => [reminders];
}

/// Show loading
class HomeLoading extends HomeState {
  const HomeLoading(super.reminders);
}

/// Loaded state
class HomeLoaded extends HomeState {
  const HomeLoaded(super.reminders);
}

class HomeError extends HomeState {
  final Object error;

  const HomeError(this.error, super.reminders);

  @override
  List<Object> get props => [...super.props, error];
}
