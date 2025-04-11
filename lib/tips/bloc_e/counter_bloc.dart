// lib/blocs/counter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterUpdatedState(0)) {
    // ✅ 加上這兩個事件的註冊
    on<IncrementCounterEvent>((event, emit) {
      final current = (state as CounterUpdatedState).counter;
      emit(CounterUpdatedState(current + 1));
    });

    on<DecrementCounterEvent>((event, emit) {
      final current = (state as CounterUpdatedState).counter;
      emit(CounterUpdatedState(current - 1));
    });
  }

  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is IncrementCounterEvent) {
      int currentCount = (state is CounterUpdatedState)
          ? (state as CounterUpdatedState).counter
          : 0;
      yield CounterUpdatedState(currentCount + 1);
    } else if (event is DecrementCounterEvent) {
      int currentCount = (state is CounterUpdatedState)
          ? (state as CounterUpdatedState).counter
          : 0;
      yield CounterUpdatedState(currentCount - 1);
    }
  }
}
