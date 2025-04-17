import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../element/tip_button.dart';

// 這是資料邏輯（ViewModel）
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // 通知 UI 更新
  }
}

// 這是主頁面
class StateManagementExample extends StatelessWidget {
  const StateManagementExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterModel(), // 提供 CounterModel 給下層使用
      child: Scaffold(
        appBar: AppBar(title: const Text('狀態管理示範')),
        body: const Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CounterView(),
          IncrementButton(),
        ])),
      ),
    );
  }
}

// UI 部分：顯示計數
class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, model, child) {
        return Text(
          '你按了 ${model.count} 次',
          style: const TextStyle(fontSize: 24),
        );
      },
    );
  }
}

// UI 部分：增加按鈕
class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TipButton(
      onPressed: () => context.read<CounterModel>().increment(),
      text: '加一',
    );
  }
}
