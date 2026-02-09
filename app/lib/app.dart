import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'screens/widget_editor_screen.dart';
import 'theme/app_theme.dart';

class WidgetinApp extends StatelessWidget {
  const WidgetinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgetin',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const HomeShell(),
      routes: {
        '/editor': (_) => const WidgetEditorScreen(),
      },
    );
  }
}
