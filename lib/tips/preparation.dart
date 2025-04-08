// 預備頁面
import 'package:flutter/material.dart';

class PreparationPage extends StatelessWidget {
  const PreparationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('預備頁面')),
      body: const Center(
        child: Text('這是預備頁面'),
      ),
    );
  }
}