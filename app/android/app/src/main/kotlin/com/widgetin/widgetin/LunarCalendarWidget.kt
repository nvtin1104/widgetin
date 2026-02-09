package com.widgetin.widgetin

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews

class LunarCalendarWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val views = RemoteViews(context.packageName, R.layout.lunar_calendar_widget_layout)

            // Check if data has been synced from the Flutter app
            val hasData = prefs.contains("lunar_date")

            if (!hasData) {
                // Show placeholder when no data is available
                views.setTextViewText(R.id.tv_solar_date, "")
                views.setTextViewText(R.id.tv_lunar_date, "Widgetin")
                views.setTextViewText(R.id.tv_can_chi, "Mở ứng dụng để thiết lập")
                views.setTextViewText(R.id.tv_hoang_dao, "")
            } else {
                // Set lunar data from SharedPreferences
                val solarDate = prefs.getString("lunar_solar_date", "--/--/----") ?: "--/--/----"
                val lunarDate = prefs.getString("lunar_date", "--/--") ?: "--/--"
                val lunarYear = prefs.getString("lunar_year", "") ?: ""
                val canChiDay = prefs.getString("lunar_can_chi_day", "") ?: ""
                val hoangDao = prefs.getString("lunar_hoang_dao", "") ?: ""

                views.setTextViewText(R.id.tv_solar_date, solarDate)
                views.setTextViewText(R.id.tv_lunar_date, lunarDate)
                views.setTextViewText(R.id.tv_can_chi, "$lunarYear - $canChiDay")
                views.setTextViewText(R.id.tv_hoang_dao, "Giờ tốt: $hoangDao")
            }

            // Apply text color from config
            val textColor = prefs.getLong("widget_text_color", 0xFF2D2D2D).toInt()
            views.setTextColor(R.id.tv_solar_date, textColor)
            views.setTextColor(R.id.tv_lunar_date, textColor)
            views.setTextColor(R.id.tv_can_chi, textColor)
            views.setTextColor(R.id.tv_hoang_dao, textColor)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
