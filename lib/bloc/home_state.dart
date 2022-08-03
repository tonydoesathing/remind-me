part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<Reminder> reminders;
  final List<Reminder>? selected;
  const HomeState(this.reminders, this.selected);

  @override
  List<Object?> get props => [reminders, selected];
}

/// Show loading
class HomeLoading extends HomeState {
  const HomeLoading(super.reminders, super.selected);
}

/// Loaded state
class HomeLoaded extends HomeState {
  const HomeLoaded(super.reminders, super.selected);
}

/// Display an error
class HomeError extends HomeState {
  final Object error;

  const HomeError(this.error, super.reminders, super.selected);

  @override
  List<Object?> get props => [...super.props, error];
}
