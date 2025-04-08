import 'package:flutter/material.dart';

class TipButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TipButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.center, // 讓按鈕居中
        child: SizedBox(
          width: double.infinity, // 使按鈕寬度填滿可用空間
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Center( // 確保文字居中
              child: Text(
                text,
                textAlign: TextAlign.center, // 確保文字在按鈕內居中
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
