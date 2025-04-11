import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../element/tip_button.dart';
import 'model/counter_model.dart';




class ProviderCounterExample extends StatelessWidget {
  const ProviderCounterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: const CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterModel>().count;

    return Scaffold(
      appBar: AppBar(title: const Text('Provider 範例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('計數：$counter', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TipButton(
              onPressed: () => context.read<CounterModel>().increment(),
              text: '加一',
            ),
          ],
        ),
      ),
    );
  }
}
