import 'package:flutter/foundation.dart';
import '../models/lunar_date.dart';
import '../services/lunar_calendar_service.dart';

class LunarCalendarProvider extends ChangeNotifier {
  final LunarCalendarService _service = LunarCalendarService();
  LunarDate? _todayLunar;
  String? _error;

  LunarDate? get todayLunar => _todayLunar;
  String? get error => _error;

  void loadToday() {
    try {
      _error = null;
      _todayLunar = _service.getToday();
    } catch (e) {
      _error = e.toString();
      _todayLunar = null;
    }
    notifyListeners();
  }
}
