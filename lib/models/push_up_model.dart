import 'package:flutter_bloc/flutter_bloc.dart';

enum PushUpState {
  neutral,
  init,
  complete,
  none
}

class PushUpCounter extends Cubit<PushUpState> {
  int counter = 0;

  PushUpCounter() : super(PushUpState.neutral);

  void increment() {
    counter++;
    emit(state);  // Re-emit the current state
  }

  void setPushUpState(PushUpState newState) {
    emit(newState);
  }

  void reset() {
    counter = 0;
    emit(PushUpState.neutral); // Reset to the initial state
  }
}
