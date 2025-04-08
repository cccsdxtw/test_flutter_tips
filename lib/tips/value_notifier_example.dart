import 'package:flutter/material.dart';
import 'package:test_flutter_tips/element/tip_button.dart';

import '../globals_debug.dart';

class ValueNotifierExample extends StatelessWidget {
  ValueNotifierExample({super.key});

  final ValueNotifier<int> counter = ValueNotifier<int>(0);
  final ValueNotifier<String> message = ValueNotifier<String>("Hello");
  final ValueNotifier<bool> isVisible = ValueNotifier<bool>(true);
  final ValueNotifier<List<String>> items =
  ValueNotifier<List<String>>(["Item 1", "Item 2"]);

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 ValueNotifierExample build");

    return Scaffold(
      appBar: AppBar(title: const Text("ValueNotifier 範例")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: [
          ValueListenableBuilder<int>(
            valueListenable: counter,
            builder: (_, value, __) {
              logger.e("🔁 counter build: $value");
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 置中
                children:[Text("Counter: $value"),]
              );
            },
          ),
          TipButton(
            onPressed: () => counter.value++,
            text: "增加 Counter",
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<String>(
            valueListenable: message,
            builder: (_, value, __) {
              logger.e("🔁 message build: $value");
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 置中
                children: [Text("Message: $value")],
              );
            },
          ),
          TipButton(
            onPressed: () => message.value = "Hi at ${DateTime.now()}",
            text: "改變 Message",
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<bool>(
            valueListenable: isVisible,
            builder: (_, value, __) {
              logger.e("🔁 isVisible build: $value");
              return Visibility(
                visible: value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("你看得到我 👀"),
                    Text("還有我 🙋"),
                  ],
                ),
              );
            },
          ),
          TipButton(
            onPressed: () => isVisible.value = !isVisible.value,
            text: "切換可見性",
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<List<String>>(
            valueListenable: items,
            builder: (_, value, __) {
              logger.e("🔁 items build: $value");
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 置中
                children: value.map((e) => Text(e)).toList(),
              );
            },
          ),
          TipButton(
            onPressed: () {
              final newList = List<String>.from(items.value)
                ..add("Item ${items.value.length + 1}");
              items.value = newList;
            },
            text: "新增 Item",
          ),
        ],
      ),
    );
  }
}
