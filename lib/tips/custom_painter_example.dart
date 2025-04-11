// lib/pages/custom_painter_example.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 狀態模型
class CircleModel with ChangeNotifier {
  double _radius = 50;

  double get radius => _radius;

  void updateRadius(double newRadius) {
    if (_radius != newRadius) {
      _radius = newRadius;
      notifyListeners(); // 通知 widget 重建
    }
  }
}

// 自訂畫家
class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}

// 畫布元件
class CircleCanvas extends StatelessWidget {
  const CircleCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = context
        .watch<CircleModel>()
        .radius;

    return CustomPaint(
      painter: CirclePainter(radius),
      size: const Size(200, 200),
    );
  }
}

// 主頁面
class CustomPainterExample extends StatefulWidget {
  const CustomPainterExample({super.key});

  @override
  State<CustomPainterExample> createState() => _CustomPainterExampleState();
}

class _CustomPainterExampleState extends State<CustomPainterExample> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CircleModel(),
        builder: (context, child) {
          return
            Scaffold(
              appBar: AppBar(title: const Text('CustomPainter 控制範例')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleCanvas(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final model = context.read<CircleModel>();
                        model.updateRadius(model.radius + 10);
                      },
                      child: const Text('放大'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final model = context.read<CircleModel>();
                        model.updateRadius(model.radius - 10);
                      },
                      child: const Text('縮小'),
                    ),
                  ],
                ),
              ),
            );
        }
    );
  }
}
