import 'package:flutter/material.dart';

import '../globals_debug.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  // TickerProviderStateMixin是因為 我用了兩個AnimationController
  // 如果只要一個AnimationController SingleTickerProviderStateMixin比較省
  late AnimationController _controller;
  late AnimationController _controllerToprogress;
  late Animation<double> _circleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controllerToprogress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _circleAnimation = Tween<double>(begin: 50, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controllerToprogress, curve: Curves.linear),
    );

    _controller.repeat(reverse: true); // 圓形動畫會重複播放
    _controllerToprogress.forward(); //進度條只會跑一遍
  }

  @override
  Widget build(BuildContext context) {
    logger.d("總之 先看看有沒有重複build");

    // 取得螢幕寬度
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: const Text('動畫效能優化'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center, // 把所有子元件都放置於中心
          children: [
            // 使用 RepaintBoundary 隔離圓形動畫區塊
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _circleAnimation,
                builder: (context, child) {
                  return Container(
                    width: _circleAnimation.value,
                    height: _circleAnimation.value,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ),
            // 使用 RepaintBoundary 隔離進度條區塊
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: screenWidth-50, // 設定進度條寬度
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
