import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/lunar_calendar_provider.dart';
import 'providers/widget_config_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LunarCalendarProvider()..loadToday(),
        ),
        ChangeNotifierProvider(
          create: (_) => WidgetConfigProvider()..loadConfig(),
        ),
      ],
      child: const WidgetinApp(),
    ),
  );
}
