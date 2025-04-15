import 'package:flutter/material.dart';
import '../globals_debug.dart'; // 你原本的 logger

// 主畫面
class DidUpdateExample extends StatefulWidget {
  const DidUpdateExample({super.key});

  @override
  State<DidUpdateExample> createState() => _DidUpdateExampleState();
}

class _DidUpdateExampleState extends State<DidUpdateExample> {
  String name = "Alice";

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 DidUpdateExample build (name: $name)");

    return Scaffold(
      appBar: AppBar(title: const Text('didUpdateWidget 範例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NameDisplay(name: name),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = name == "Alice" ? "Bob" : "Alice";
                });
              },
              child: const Text("切換名字"),
            )
          ],
        ),
      ),
    );
  }
}

// Stateful 子元件：會使用 didUpdateWidget()
class NameDisplay extends StatefulWidget {
  final String name;
  const NameDisplay({super.key, required this.name});

  @override
  State<NameDisplay> createState() => _NameDisplayState();
}

class _NameDisplayState extends State<NameDisplay> {
  @override
  void didUpdateWidget(covariant NameDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.e("🌀 didUpdateWidget: ${oldWidget.name} → ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 NameDisplay build (${widget.name})");
    return Text(
      "Hello, ${widget.name}!",
      style: const TextStyle(fontSize: 24),
    );
  }
}
