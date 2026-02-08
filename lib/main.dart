import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/lunar_calendar_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LunarCalendarProvider()..loadToday(),
        ),
      ],
      child: const WidgetinApp(),
    ),
  );
}
