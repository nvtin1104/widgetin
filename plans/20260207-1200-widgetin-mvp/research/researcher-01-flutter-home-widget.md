# Flutter Home Screen Widget Integration Research - Widgetin MVP

**Date:** 2026-02-07 | **Project:** Widgetin | **Focus:** Android home widget + iOS architecture

## 1. home_widget Package (Latest v0.5.x)

**Status:** Stable, well-maintained. Bridges Flutter ↔ Android native widgets via platform channels.

**Core API:**
- `HomeWidget.saveWidgetData<T>(key, value)` - Store config/state in SharedPreferences
- `HomeWidget.getWidgetData<T>(key, defaultValue)` - Retrieve stored data
- `HomeWidget.updateWidget(androidName, qualifiedAndroidName)` - Force widget refresh from Flutter
- `HomeWidget.widgetClicked` - Stream for widget interaction callbacks
- **Limitations:** iOS native widget support pending (use dummy implementation for MVP)

**Android Bridge Mechanism:**
- Uses Method Channels (Flutter↔Kotlin/Java bridge)
- Data persisted in `SharedPreferences` under app-specific namespace
- Widget process spawned separately; accesses shared prefs directly
- No direct inter-process communication (IPC) needed

**Setup Steps (Android):**
1. Add to `pubspec.yaml`: `home_widget: ^0.5.x`
2. Configure `android/app/build.gradle`: minSdkVersion 21+
3. Create Kotlin `AppWidget` class extending `AppWidgetProvider`
4. Define `widget_layout.xml` (RemoteViews compatible)
5. Register in `AndroidManifest.xml` with `<appwidget-provider>` metadata
6. Add `UPDATE_APPWIDGET_PROVIDER` permission

## 2. Android Native Widget Requirements

**AppWidgetProvider (Kotlin):**
```kotlin
class HomeWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { updateAppWidget(context, appWidgetManager, it) }
    }
}
```

**Widget Layout (`widget_layout.xml`):**
- RemoteViews only (no complex Views)
- Standard widgets: FrameLayout, LinearLayout, ImageView, TextView
- Constraints: API 14+ support, ~100KB max size, ~512 item limit
- No custom fonts; limited drawable support

**Manifest Config:**
```xml
<receiver android:name=".HomeWidget" android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data android:name="android.appwidget.provider"
               android:resource="@xml/appwidget_info" />
</receiver>
```

**Jetpack Glance Comparison:**
- **Glance:** Declarative (Compose-like), modern, Type-safe RemoteViews builder
- **Traditional:** Imperative RemoteViews manipulation, more control
- **Recommendation:** Glance 1.0+ for new projects; simpler widget logic. home_widget works with both.

## 3. Data Flow: Flutter → Android Widget

**SharedPreferences Approach:**

1. Flutter stores data → `HomeWidget.saveWidgetData<String>('key', 'value')`
2. Android widget reads on update → `context.getSharedPreferences(...).getString("key", "default")`
3. Trigger widget refresh → `HomeWidget.updateWidget(androidName: 'HomeWidget')`
4. System triggers → OnUpdate broadcast → AppWidgetProvider.onUpdate() → RemoteViews refresh (~500ms-2s latency)

## 4. Best Practices

**Widget Sizing:** 2x1 (100dp×100dp), 4x2 (200dp×100dp), 4x4 (200dp×200dp)

**Refresh Strategies:**
- User-triggered: Manual button tap → `HomeWidget.updateWidget()`
- Periodic: `updatePeriodMillis` (15min+ minimum, system may override)
- FCM: Time-sensitive updates
- Avoid: Sub-minute cycles (battery drain)

**Background Updates:** WorkManager for scheduled syncs (respects Doze), avoid AlarmManager

## 5. State Management: Riverpod vs Provider

| Aspect | Provider | Riverpod |
|--------|----------|----------|
| Size | ~20KB | ~40KB |
| Complexity | Simple | More boilerplate |
| Testing | Decent | Superior |
| Scale | Small-medium | Large apps |

**MVP Recommendation:** Use **Provider** - lighter, sufficient for widget config storage.
