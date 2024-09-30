import 'package:flutter_bloc/flutter_bloc.dart';

enum SquatState {
  stand,   // Standing position
  down,    // Going down
  bottom,  // Lowest position
  up,       // Coming up
  none
}

class SquatCounter extends Cubit<SquatState> {
  int counter = 0;

  SquatCounter() : super(SquatState.stand);

  void setSquatState(SquatState current) {
    emit(current);
  }

  void increment() {
    counter++;
    emit(SquatState.stand);  // Ensure state is reset to stand
  }

  void reset() {
    counter = 0;
    emit(SquatState.stand);
  }
}

