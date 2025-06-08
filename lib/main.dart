import 'package:bizorda/app.dart';
import 'package:bizorda/features/messages/messages_page.dart';
import 'package:bizorda/routes.dart';
import 'package:bizorda/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}


