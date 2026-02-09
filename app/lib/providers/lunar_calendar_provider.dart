import 'package:flutter/foundation.dart';
import '../models/lunar_date.dart';
import '../services/lunar_calendar_service.dart';
import '../services/widget_data_sync_service.dart';

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
      // Sync lunar data to native widget (fire-and-forget)
      if (_todayLunar != null) {
        _syncToWidget(_todayLunar!);
      }
    } catch (e) {
      _error = e.toString();
      _todayLunar = null;
    }
    notifyListeners();
  }

  Future<void> _syncToWidget(LunarDate lunar) async {
    try {
      await WidgetDataSyncService.syncLunarData(lunar);
      await WidgetDataSyncService.updateWidget();
    } catch (_) {
      // Widget sync failure is non-critical
    }
  }
}
