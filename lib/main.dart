import 'package:expense_tracker/core/di/service_locator.dart'
    as service_locator;
import 'package:expense_tracker/core/router/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  service_locator.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
