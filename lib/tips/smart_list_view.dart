import 'package:flutter/material.dart';

class SmartListView extends StatefulWidget {
  const SmartListView({super.key});

  @override
  State<SmartListView> createState() => _SmartListViewState();
}

class _SmartListViewState extends State<SmartListView> {
  final ScrollController _scrollController = ScrollController();

  static const int pageSize = 30;
  static const int maxItems = 120;
  List<int> items = List.generate(pageSize, (i) => i + 1);
  bool _isLoadingUp = false;
  bool _isLoadingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !_isLoadingUp) {
      _loadMoreUp();
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingDown) {
      _loadMoreDown();
    }
  }

  void _loadMoreDown() async {
    setState(() => _isLoadingDown = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final last = items.last;
    final newItems = List.generate(pageSize, (i) => last + i + 1);

    setState(() {
      items.addAll(newItems);
      if (items.length > maxItems) {
        items.removeRange(0, items.length - maxItems);
      }
      _isLoadingDown = false;
    });
  }

  void _loadMoreUp() async {
    setState(() => _isLoadingUp = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final first = items.first;
    final newItems = List.generate(pageSize, (i) => first - i - 1).reversed.toList();

    setState(() {
      items.insertAll(0, newItems);
      if (items.length > maxItems) {
        items.removeRange(maxItems, items.length);
      }

      // 保持視覺位置不跳動
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.pixels + pageSize * 50);
      });

      _isLoadingUp = false;
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
      appBar: AppBar(title: const Text("📘 Smart 三段式 ListView")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text('Item $item'),
          );
        },
      ),
    );
  }
}
