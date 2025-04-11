import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../element/tip_button.dart';
import 'model/counter_model.dart';

/// Riverpod 專用的 provider 包裝
final counterProvider = ChangeNotifierProvider<CounterModel>((ref) {
  return CounterModel();
});

class RiverpodCounterExample extends ConsumerWidget {
  const RiverpodCounterExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterModel = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 範例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('計數：${counterModel.count}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TipButton(
              onPressed: () => ref.read(counterProvider).increment(),
              text: '加一',
            ),
          ],
        ),
      ),
    );
  }
}
