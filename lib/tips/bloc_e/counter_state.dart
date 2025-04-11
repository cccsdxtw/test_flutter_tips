// lib/blocs/counter_state.dart
abstract class CounterState {}

class CounterInitialState extends CounterState {}

class CounterUpdatedState extends CounterState {
  final int counter;
  CounterUpdatedState(this.counter);
}
