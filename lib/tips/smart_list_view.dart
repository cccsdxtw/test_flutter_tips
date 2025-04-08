import 'package:flutter/material.dart';

class SmartListView extends StatefulWidget {
  const SmartListView({super.key});

  @override
  State<SmartListView> createState() => _SmartListViewState();
}

class _SmartListViewState extends State<SmartListView> {
  final ScrollController _scrollController = ScrollController();

  // 初始資料及參數
  List<String> items = [];
  int firstItemIndex = 0;
  // 當列表項目數超過 maxItems 時，才修剪資料（避免頻繁刪除導致滾動跳動）
  final int maxItems = 200;
  final int batchSize = 30;

  bool _isLoadingTop = false;
  bool _isLoadingBottom = false;

  // 預估每個項目的高度（如果高度固定，可以用此數值進行補償）
  final double itemHeight = 60.0;

  @override
  void initState() {
    super.initState();
    _initItems();
    _scrollController.addListener(_onScroll);
  }

  void _initItems() {
    setState(() {
      items = List.generate(batchSize, (i) => 'Item $i');
      firstItemIndex = 0;
    });
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels <= 100 && !_isLoadingTop) {
      _loadMoreTop();
    }
    if (position.pixels >= position.maxScrollExtent - 100 && !_isLoadingBottom) {
      _loadMoreBottom();
    }
  }

  void _loadMoreTop() async {
    if (firstItemIndex <= 0 || _isLoadingTop) return;
    setState(() => _isLoadingTop = true);

    final double scrollOffsetBefore = _scrollController.offset;
    await Future.delayed(const Duration(seconds: 1));

    final int start = (firstItemIndex - batchSize).clamp(0, firstItemIndex);
    final List<String> newItems = List.generate(
      firstItemIndex - start,
          (i) => 'Item ${start + i}',
    );
    final int newItemsCount = newItems.length;

    setState(() {
      items.insertAll(0, newItems);
      firstItemIndex = start;
      _isLoadingTop = false;
      // 這裡不做嚴格的修剪，因為向上加載通常不需要大量修剪
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double deltaScroll = newItemsCount * itemHeight;
      _scrollController.jumpTo(scrollOffsetBefore + deltaScroll);
    });
  }

  void _loadMoreBottom() async {
    if (_isLoadingBottom) return;
    // 記錄原來的滾動位置
    final double scrollOffsetBefore = _scrollController.offset;
    setState(() => _isLoadingBottom = true);
    await Future.delayed(const Duration(seconds: 1));

    final int start = firstItemIndex + items.length;
    final List<String> newItems = List.generate(
      batchSize,
          (i) => 'Item ${start + i}',
    );

    setState(() {
      items.addAll(newItems);
      _isLoadingBottom = false;
    });

    int removed = 0;
    // 當資料超過 maxItems 時，移除上方過舊資料
    if (items.length > maxItems) {
      removed = items.length - maxItems;
      setState(() {
        items = items.sublist(removed);
        firstItemIndex += removed;
      });
    }

    // 補償因移除資料而改變的滾動位置
    if (removed > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final double newScrollOffset = (scrollOffsetBefore - removed * itemHeight)
            .clamp(0.0, _scrollController.position.maxScrollExtent);
        _scrollController.jumpTo(newScrollOffset);
      });
    }
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
        itemCount: items.length +
            (_isLoadingTop ? 1 : 0) +
            (_isLoadingBottom ? 1 : 0),
        itemBuilder: (context, index) {
          // 上方 loading indicator
          if (_isLoadingTop && index == 0) {
            return const Center(child: CircularProgressIndicator());
          }
          // 下方 loading indicator
          if (_isLoadingBottom &&
              index == items.length + (_isLoadingTop ? 1 : 0)) {
            return const Center(child: CircularProgressIndicator());
          }
          final int realIndex = index - (_isLoadingTop ? 1 : 0);
          final String item = items[realIndex];
          return ListTile(
            title: Text(item),
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Tapped on: $item')));
            },
          );
        },
      ),
    );
  }
}
