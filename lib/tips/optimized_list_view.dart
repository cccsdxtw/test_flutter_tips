import 'package:flutter/material.dart';
import '../globals_debug.dart';

class OptimizedListViewPage extends StatefulWidget {
  const OptimizedListViewPage({super.key});

  @override
  State<OptimizedListViewPage> createState() => _OptimizedListViewPageState(); // 使用私有類別
}

class _OptimizedListViewPageState extends State<OptimizedListViewPage> {
  // 預設顯示30個項目
  final List<String> items = List.generate(30, (index) => 'Item $index');
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 設置滾動控制器監聽
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // 滑動到底部，開始加載更多資料
        _loadMoreData();
        logger.e('滑動到底部，開始加載更多資料');
      }
    });
  }

  void _loadMoreData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    // 模擬加載更多資料
    await Future.delayed(const Duration(seconds: 2));

    // 加載新資料並更新列表
    final newItems = List.generate(30, (index) => 'New Item ${items.length + index}');
    setState(() {
      items.addAll(newItems);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ListView.builder 優化")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + (_isLoading ? 1 : 0), // 顯示額外的加載指示器
        cacheExtent: 90,//只保留這麼多
        itemBuilder: (context, index) {
          if (index == items.length) {
            // 顯示加載指示器
            return const Center(child: CircularProgressIndicator());
          }
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              // 清除已顯示的吐司
              ScaffoldMessenger.of(context).clearSnackBars();
              // 點擊項目後顯示吐司
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on: ${items[index]}')),
              );
              logger.e('Tapped on: ${items[index]}');
            },
          );
        },
      ),
    );
  }
}
