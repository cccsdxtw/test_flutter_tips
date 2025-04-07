// lib/globals_debug.dart
import 'package:logger/logger.dart';

// 創建全局的 Logger 實例
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // 不顯示方法
    errorMethodCount: 5,
    // 顯示錯誤的最大層級
    lineLength: 80,
    // 日誌顯示的寬度
    colors: true,
    // 開啟顏色
    printEmojis: false,
    // 關閉表情符號
    printTime: false, // 顯示時間
  ),
);

// 定義一個全局變數
int counter = 0;
