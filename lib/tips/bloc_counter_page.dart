// lib/pages/counter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../element/tip_button.dart';
import 'bloc_e/counter_bloc.dart';
import 'bloc_e/counter_event.dart';
import 'bloc_e/counter_state.dart';


class BlocCounterPage extends StatelessWidget {
  const BlocCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc 範例')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            int counter = 0;
            if (state is CounterUpdatedState) {
              counter = state.counter;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('計數：$counter', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TipButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementCounterEvent());
                  },
                  text: '加一',
                ),
                TipButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementCounterEvent());
                  },
                  text: '減一',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
