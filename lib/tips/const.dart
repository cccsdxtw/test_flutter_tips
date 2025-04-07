import 'package:flutter/material.dart';

import '../globals_debug.dart';

class Const extends StatefulWidget {
  const Const({super.key});

  @override
  State<Const> createState() => _Const();
}

class _Const extends State<Const> {
  final List<String?> _answers = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📘 Simple Exam')),
      body: Column(
        children: [
          // 靜態的元件
          const StaticWidget(),

          // 問題列表
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return QuestionTile(
                  key: ValueKey(index),  // 使用ValueKey來確保唯一性
                  onChanged: (val) {
                    setState(() {
                      _answers[index] = val;
                    });
                  },
                  answer: _answers[index],
                  questionText: 'Question ${index + 1}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 靜態元件：這個元件不會重建
class StaticWidget extends StatelessWidget {
  const StaticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e("✅ StaticWidget build");
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber,
      child: const Text(
        '這是靜態元件，不會重建',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// 題目選項元件
class QuestionTile extends StatelessWidget {
  final String? answer;
  final String questionText;
  final ValueChanged<String?> onChanged;

  const QuestionTile({
    super.key,
    required this.answer,
    required this.onChanged,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 QuestionTile build: $questionText");

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              value: 'Option A',
              groupValue: answer,
              onChanged: onChanged,
              title: const Text('Option A'),
            ),
            RadioListTile<String>(
              value: 'Option B',
              groupValue: answer,
              onChanged: onChanged,
              title: const Text('Option B'),
            ),
            RadioListTile<String>(
              value: 'Option C',
              groupValue: answer,
              onChanged: onChanged,
              title: const Text('Option C'),
            ),
          ],
        ),
      ),
    );
  }
}
