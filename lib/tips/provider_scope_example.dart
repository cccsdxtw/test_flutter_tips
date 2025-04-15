import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../element/tip_button.dart';
import '../globals_debug.dart'; // 要有 logger.e 用來印出重建訊息

// ✅ 模型
class CounterModel with ChangeNotifier {
  int _count = 0;
  int _anotherValue = 100;

  int get count => _count;
  int get anotherValue => _anotherValue;

  void increment() {
    _count++;
    notifyListeners();
  }

  void updateAnotherValue(int value) {
    _anotherValue = value;
    notifyListeners();
  }
}

// ✅ 頁面主體
class ProviderScopeExample extends StatelessWidget {
  const ProviderScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 ProviderScopeExample build");
    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child:  Scaffold(
        appBar: AppBar(title: const Text("Provider 三種用法")),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              WatchSection(),
              Divider(),
              ConsumerSection(),
              Divider(),
              SelectorSection(),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ 用 context.watch 的區塊（整個 widget 重建）
class WatchSection extends StatelessWidget {
  const WatchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterModel>().count;
    logger.e("🔁 WatchSection build");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("context.watch: $count"),
        TipButton(
          onPressed: () => context.read<CounterModel>().increment(),
          text: '＋',
        ),
      ],
    );
  }
}

// ✅ 用 Consumer 的區塊（只重建 builder 內部）
class ConsumerSection extends StatelessWidget {
  const ConsumerSection({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 ConsumerSection build");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<CounterModel>(
          builder: (_, model, __) {
            logger.e("🔁 Consumer builder build");
            return Text("Consumer: ${model.count}");
          },
        ),
        TipButton(
          onPressed: () => context.read<CounterModel>().increment(),
          text: '＋',
        ),
      ],
    );
  }
}

// ✅ 用 Selector 的區塊（可選擇重建條件）
class SelectorSection extends StatelessWidget {
  const SelectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 SelectorSection build");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Selector<CounterModel, int>(
          selector: (_, model) => model.count,
          shouldRebuild: (prev, next) {
            logger.e("🟡 Selector shouldRebuild: $prev -> $next");
            return next % 2 == 0; // 只在 count 為偶數時才重建
          },
          builder: (_, count, __) {
            logger.e("🔁 Selector builder build");
            return Text("Selector: $count");
          },
        ),
        TipButton(
          onPressed: () => context.read<CounterModel>().increment(),
          text: '＋',
        ),
      ],
    );
  }
}
