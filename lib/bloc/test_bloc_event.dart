part of 'test_bloc_bloc.dart';

abstract class TestBlocEvent extends Equatable {
  final int lastCount;

  const TestBlocEvent(this.lastCount);

  @override
  List<Object> get props => [];
}

class AddCounter extends TestBlocEvent {
  const AddCounter(super.lastCount);
}
