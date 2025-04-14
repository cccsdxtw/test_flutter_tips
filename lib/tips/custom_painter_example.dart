import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../element/tip_button.dart'; // 請確保這個有定義
import '../globals_debug.dart'; // 請確保這個 logger 可用

// 模型
class SingleCircleModel with ChangeNotifier {
  double _radius;
  SingleCircleModel(this._radius);

  double get radius => _radius;

  void updateRadius(double newRadius) {
    if (_radius != newRadius) {
      _radius = newRadius;
      notifyListeners();
    }
  }
}

// 畫圈圈
class CirclePainter extends CustomPainter {
  final double radius;
  CirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}

// 單一圈圈 widget
class CircleWidget extends StatelessWidget {
  final int index;
  const CircleWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final radius = context.watch<SingleCircleModel>().radius;
    logger.e("🔁 Circle $index build");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: CirclePainter(radius),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TipButton(
                text: '放大 $index',
                onPressed: () {
                  final model = context.read<SingleCircleModel>();
                  model.updateRadius(model.radius + 10);
                },
              ),
              const SizedBox(width: 10),
              TipButton(
                text: '縮小 $index',
                onPressed: () {
                  final model = context.read<SingleCircleModel>();
                  model.updateRadius(model.radius - 10);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 主畫面
class CustomPainterExample extends StatelessWidget {
  const CustomPainterExample({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e("🔁 CustomPainterExample build");

    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter 控制範例')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider(
            key: ValueKey(index),
            create: (_) => SingleCircleModel(30.0 + index * 20),
            child: CircleWidget(index: index),
          );
        },
      ),
    );
  }
}
