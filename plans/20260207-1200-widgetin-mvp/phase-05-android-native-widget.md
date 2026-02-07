# Phase 05 - Android Native Widget

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** Phase 01 (project), Phase 02 (lunar logic for data), Phase 04 (config saved to SharedPreferences)
- **Research:** [Flutter Home Widget](research/researcher-01-flutter-home-widget.md), [Lunar Calendar](research/researcher-02-lunar-calendar.md)

## Overview

- **Date:** 2026-02-07
- **Description:** Implement the Android native home screen widget using Kotlin AppWidgetProvider, XML RemoteViews layout, and SharedPreferences data bridge from Flutter.
- **Priority:** P0
- **Implementation Status:** Pending
- **Review Status:** Not started

## Key Insights

- RemoteViews only: FrameLayout, LinearLayout, TextView, ImageView (no custom Views)
- Data bridge: Flutter `HomeWidget.saveWidgetData()` → Android reads same SharedPreferences
- `updatePeriodMillis`: 86400000ms (24h) sufficient for daily calendar; system enforces 15min minimum
- No custom fonts in RemoteViews; use system default
- Widget sizing: target 4x2 (roughly 250dp x 110dp) for optimal info density
- Background color via `GradientDrawable` set programmatically on root layout

## Requirements

- Kotlin `LunarCalendarWidget` extending `AppWidgetProvider`
- XML layout displaying: solar date, lunar date, Can Chi, Giờ Hoàng Đạo
- Read config (bg color, text color, border radius) from SharedPreferences
- Read lunar data from SharedPreferences (written by Flutter)
- Daily auto-update via `updatePeriodMillis`
- Manual refresh from Flutter via `HomeWidget.updateWidget()`
- AppWidgetProviderInfo XML with sizing and preview
- AndroidManifest.xml receiver registration

## Architecture

```
Data Flow:
  Flutter App                          Android Widget Process
  ┌──────────────┐                    ┌──────────────────────┐
  │ Save lunar   │──SharedPrefs──────>│ Read lunar data      │
  │ data + config│                    │ Build RemoteViews    │
  │ via home_wdgt│                    │ Set text/colors      │
  └──────────────┘                    │ Apply to widget      │
                                      └──────────────────────┘

SharedPreferences Keys (written by Flutter, read by Android):
  "lunar_solar_date"     → "07/02/2026"
  "lunar_date"           → "20/01"
  "lunar_year"           → "Bính Ngọ"
  "lunar_can_chi_day"    → "Nhâm Thìn"
  "lunar_hoang_dao"      → "Tý, Sửu, Thìn, Tỵ, Mùi, Tuất"
  "widget_bg_color"      → 4294965235 (int)
  "widget_text_color"    → 4281216557 (int)
  "widget_border_radius" → 16.0 (float)
```

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `android/app/src/main/kotlin/.../LunarCalendarWidget.kt` | Create | AppWidgetProvider |
| `android/app/src/main/res/layout/lunar_calendar_widget_layout.xml` | Create | RemoteViews layout |
| `android/app/src/main/res/xml/lunar_calendar_widget_info.xml` | Create | Widget metadata |
| `android/app/src/main/res/drawable/widget_background.xml` | Create | Rounded rect shape |
| `android/app/src/main/AndroidManifest.xml` | Modify | Register receiver |
| `lib/services/widget_data_sync_service.dart` | Create | Push lunar data to SharedPrefs |
| `lib/providers/widget_config_provider.dart` | Modify | Call sync after save |

## Implementation Steps

1. **Create `android/app/src/main/res/layout/lunar_calendar_widget_layout.xml`**:
   ```xml
   <LinearLayout android:id="@+id/widget_root"
       android:layout_width="match_parent" android:layout_height="match_parent"
       android:orientation="vertical" android:padding="12dp"
       android:background="@drawable/widget_background">
     <TextView android:id="@+id/tv_solar_date"
         android:layout_width="wrap_content" android:layout_height="wrap_content"
         android:textSize="14sp" android:text="07/02/2026" />
     <TextView android:id="@+id/tv_lunar_date"
         android:layout_width="wrap_content" android:layout_height="wrap_content"
         android:textSize="24sp" android:textStyle="bold" android:text="20/01" />
     <TextView android:id="@+id/tv_can_chi"
         android:layout_width="wrap_content" android:layout_height="wrap_content"
         android:textSize="12sp" android:text="Bính Ngọ - Nhâm Thìn" />
     <TextView android:id="@+id/tv_hoang_dao"
         android:layout_width="wrap_content" android:layout_height="wrap_content"
         android:textSize="11sp" android:text="Giờ tốt: Tý, Sửu, Thìn" />
   </LinearLayout>
   ```

2. **Create `android/app/src/main/res/drawable/widget_background.xml`**:
   ```xml
   <shape xmlns:android="http://schemas.android.com/apk/res/android">
     <solid android:color="#FAF8F3" />
     <corners android:radius="16dp" />
   </shape>
   ```

3. **Create `android/app/src/main/res/xml/lunar_calendar_widget_info.xml`**:
   ```xml
   <appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
       android:minWidth="250dp" android:minHeight="110dp"
       android:updatePeriodMillis="86400000"
       android:initialLayout="@layout/lunar_calendar_widget_layout"
       android:resizeMode="horizontal|vertical"
       android:widgetCategory="home_screen" />
   ```

4. **Create `LunarCalendarWidget.kt`** (in app's Kotlin package):
   ```kotlin
   class LunarCalendarWidget : AppWidgetProvider() {
       override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
           ids.forEach { id ->
               val prefs = ctx.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
               val views = RemoteViews(ctx.packageName, R.layout.lunar_calendar_widget_layout)
               views.setTextViewText(R.id.tv_solar_date, prefs.getString("lunar_solar_date", "--"))
               views.setTextViewText(R.id.tv_lunar_date, prefs.getString("lunar_date", "--"))
               views.setTextViewText(R.id.tv_can_chi, prefs.getString("lunar_year", "") + " - " + prefs.getString("lunar_can_chi_day", ""))
               views.setTextViewText(R.id.tv_hoang_dao, "Giờ tốt: " + prefs.getString("lunar_hoang_dao", ""))
               // Apply colors
               val textColor = prefs.getInt("widget_text_color", 0xFF2D2D2D.toInt())
               views.setTextColor(R.id.tv_solar_date, textColor)
               views.setTextColor(R.id.tv_lunar_date, textColor)
               views.setTextColor(R.id.tv_can_chi, textColor)
               views.setTextColor(R.id.tv_hoang_dao, textColor)
               mgr.updateAppWidget(id, views)
           }
       }
   }
   ```
   Note: Background color and border radius require programmatic `GradientDrawable` manipulation or a rendered bitmap approach. Simplify MVP to use the XML default; full dynamic bg in post-MVP.

5. **Update `AndroidManifest.xml`** - add inside `<application>`:
   ```xml
   <receiver android:name=".LunarCalendarWidget" android:exported="true">
       <intent-filter>
           <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
       </intent-filter>
       <meta-data android:name="android.appwidget.provider"
                  android:resource="@xml/lunar_calendar_widget_info" />
   </receiver>
   ```

6. **Create `lib/services/widget_data_sync_service.dart`**:
   - Method `Future<void> syncLunarData(LunarDate lunar)`:
     - `HomeWidget.saveWidgetData('lunar_solar_date', formatDate(lunar.solarDate))`
     - Save lunar_date, lunar_year, lunar_can_chi_day, lunar_hoang_dao
   - Called from `WidgetConfigProvider.saveConfig()` and on app launch

7. **Modify `lib/providers/widget_config_provider.dart`** - after `saveConfig()`, also call `WidgetDataSyncService.syncLunarData()` then `HomeWidget.updateWidget(androidName: 'LunarCalendarWidget')`.

8. **Modify `lib/main.dart`** - on app start, sync today's lunar data to SharedPreferences so the widget always has fresh data.

## Todo List

- [ ] Create XML widget layout (lunar_calendar_widget_layout.xml)
- [ ] Create widget background drawable
- [ ] Create appwidget-provider info XML
- [ ] Implement LunarCalendarWidget.kt
- [ ] Register receiver in AndroidManifest.xml
- [ ] Create WidgetDataSyncService in Flutter
- [ ] Wire sync into app launch and config save
- [ ] Test widget appears in Android widget picker
- [ ] Test data flows from Flutter to widget display
- [ ] Test daily auto-update

## Success Criteria

- Widget appears in Android home screen widget picker with correct preview
- Adding widget shows today's solar date, lunar date, Can Chi, Hoàng Đạo
- Changing config in Flutter editor updates widget within seconds
- Widget updates daily without user opening the app
- Widget survives device reboot (SharedPreferences persisted)

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| SharedPreferences namespace mismatch | High | Verify `home_widget` uses "HomeWidgetPreferences"; log key reads |
| Dynamic bg color not working in RemoteViews | Medium | MVP uses static XML bg; iterate post-MVP |
| Widget not updating after 24h (Doze) | Medium | Accept system limitation; user can open app to force sync |
| Kotlin package path mismatch | Low | Match `applicationId` in build.gradle to package in Manifest |

## Security Considerations

- SharedPreferences are app-private (MODE_PRIVATE); no external access risk
- No network calls in widget update cycle

## Next Steps

Proceed to [Phase 06 - Polish & Testing](phase-06-polish-testing.md).
