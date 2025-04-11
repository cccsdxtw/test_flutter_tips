import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:test_flutter_tips/tips/animation.dart';
import 'package:test_flutter_tips/tips/bloc_counter_page.dart';
import 'package:test_flutter_tips/tips/bloc_e/counter_bloc.dart';
import 'package:test_flutter_tips/tips/state_management_example.dart';

import 'package:test_flutter_tips/tips/image_loading.dart';
import 'package:test_flutter_tips/tips/const.dart';
import 'package:test_flutter_tips/tips/lnit_example.dart';
import 'package:test_flutter_tips/tips/optimized_list_view.dart';
import 'package:test_flutter_tips/tips/preparation.dart';
import 'package:test_flutter_tips/tips/provider_counter_example.dart';
import 'package:test_flutter_tips/tips/riverpod_counter_example.dart';
import 'package:test_flutter_tips/tips/smart_list_view.dart';
import 'package:test_flutter_tips/tips/value_notifier_example.dart';

import 'element/tip_button.dart';

void main() {
  runApp(
    const ProviderScope( // 👈 用 ProviderScope 包住整個 app
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(home: HomePage()); //正常入口
    // return  const GetMaterialApp(home: const InitExample());  //測試入口 做什麼改什麼
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // 頁面配置：這裡可以使用配置文件來進行更動態的頁面註冊
  final Map<String, Widget> pageMap = {
    '共用狀態管理Bloc': BlocProvider(
      create: (_) => CounterBloc(),
      child: const BlocCounterPage(),
    ),
    '共用狀態管理Riverpod': const RiverpodCounterExample(),
    '共用狀態管理Provider\n感覺以後可以用這個': const ProviderCounterExample(),
    '狀態管理': const StateManagementExample(),
    '動畫優化': const AnimationPage(),
    '關於圖片讀取': const ImageLoading(),
    'ListView真。三段載入\n真的難用 不推薦': const SmartListView(),
    'ListView簡易避免載入': const OptimizedListViewPage(),
    'ValueNotifier元件': const ValueNotifierExample(),
    '初始化時避免非同步': const InitExample(),
    '關於Const的復用': const Const(),
    '這頁是預留的': const PreparationPage(),
  };

  List<ButtonData> getButtons() {
    final List<ButtonData> buttons = [];

    // 從 pageMap 創建按鈕
    pageMap.forEach((pageName, pageWidget) {
      buttons.add(ButtonData(text: pageName, targetPage: pageWidget));
    });

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final List<ButtonData> buttons = getButtons();
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 小技巧練習')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shrinkWrap: true,
          children: buttons.map((buttonData) {
            return TipButton(
              text: buttonData.text,
              onPressed: () => Get.to(  ProviderScope(child: buttonData.targetPage)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ButtonData {
  final String text;
  final Widget targetPage;

  ButtonData({required this.text, required this.targetPage});
}
