import 'package:flutter/material.dart';

/// App 的根元件。
///
/// T0 只有一個空白主畫面；路由（go_router）和主題之後的 task 再加。
class RentalManagerApp extends StatelessWidget {
  const RentalManagerApp({super.key});

  static const String title = 'Rental Manager';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(appBar: AppBar(title: const Text(title))),
    );
  }
}
