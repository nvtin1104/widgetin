import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class WidgetinApp extends StatelessWidget {
  const WidgetinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgetin',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('Widgetin'),
        ),
      ),
    );
  }
}
