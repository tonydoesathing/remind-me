import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_bloc_event.dart';
part 'test_bloc_state.dart';

class TestBlocBloc extends Bloc<TestBlocEvent, TestBlocState> {
  TestBlocBloc() : super(TestBlocInitial()) {
    on<AddCounter>((event, emit) {
      emit(TestBlocLoaded(event.lastCount + 1));
    });
  }
}
