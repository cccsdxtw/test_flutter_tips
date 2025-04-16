import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_tips/element/tip_button.dart';

class CounterModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class PerformanceOverlayPage extends StatelessWidget {
  const PerformanceOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: const MaterialApp(
        showPerformanceOverlay: true,
        home: _InternalPage(),
      ),
    );
  }
}

class _InternalPage extends StatelessWidget {
  const _InternalPage();

  @override
  Widget build(BuildContext context) {
    debugPrint("🔁 _InternalPage build");

    return Scaffold(
      appBar: AppBar(title: const Text('Selector 精準更新')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WatchAll(),       // 每次更新都 rebuild
            const OnlyOdd(),       // 只有單數才 rebuild
            const OnlyEven(),      // 只有雙數才 rebuild
            const SizedBox(height: 30),
            TipButton(
              onPressed: () {
                context.read<CounterModel>().increment();
              },
              text: '增加數值',
            ),
          ],
        ),
      ),
    );
  }
}

class WatchAll extends StatelessWidget {
  const WatchAll({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterModel>().count;
    debugPrint("🔁 WatchAll build");

    return Text('全部更新：$count', style: const TextStyle(fontSize: 20));
  }
}

class OnlyOdd extends StatelessWidget {
  const OnlyOdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<CounterModel, int>(
      selector: (_, model) => model.count,
      shouldRebuild: (prev, next) {
        return next.isOdd; // 只有是「單數」才會重建
      },
      builder: (context, count, _) {
        debugPrint("🔁 OnlyOdd build");
        return Text('單數更新：$count', style: const TextStyle(fontSize: 20));
      },
    );
  }
}

class OnlyEven extends StatelessWidget {
  const OnlyEven({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<CounterModel, int>(
      selector: (_, model) => model.count,
      shouldRebuild: (prev, next) {
        return next.isEven; // 只有是「雙數」才會重建
      },
      builder: (context, count, _) {
        debugPrint("🔁 OnlyEven build");
        return Text('雙數更新：$count', style: const TextStyle(fontSize: 20));
      },
    );
  }
}
