import 'package:flutter/material.dart';
import 'dart:async';

class InitExample extends StatefulWidget {
  const InitExample({super.key});

  @override
  State<InitExample> createState() => _InitExample();
}

class _InitExample extends State<InitExample> {
  String message = "載入中...";

  @override
  void initState() {
    super.initState();
    // 避免 build 過程中觸發 setState 錯誤
    Future.microtask(() async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        message = "✅ 初始化完成！";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("初始化範例")),
      body: Center(child: Text(message, style: const TextStyle(fontSize: 20))),
    );
  }
}
