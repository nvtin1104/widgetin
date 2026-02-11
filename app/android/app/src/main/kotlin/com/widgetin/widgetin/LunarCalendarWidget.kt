package com.widgetin.widgetin

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.view.View
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

        private const val TYPE_DIGITAL_CLOCK = 0
        private const val TYPE_TEXT_BASED = 1
        private const val TYPE_MOON_PHASE = 2
        private const val TYPE_HYBRID_CALENDAR = 3

        private const val BG_TRANSPARENT = 2

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            // --- Read config ---
            val widgetType = getIntFromPrefs(prefs, "widget_type", TYPE_DIGITAL_CLOCK)
            val bgType = getIntFromPrefs(prefs, "widget_bg_type", 0)
            val textColor = getColorFromPrefs(prefs, "widget_text_color", 0xFF2D2D2D.toInt())
            val bgColor = getColorFromPrefs(prefs, "widget_bg_color", 0xFFFAF8F3.toInt())
            val showYear = prefs.getBoolean("widget_show_year", true)
            val showZodiac = prefs.getBoolean("widget_show_zodiac", true)
            val hasData = prefs.contains("lunar_date")

            // --- Pick layout based on widget type ---
            val layoutId = when (widgetType) {
                TYPE_TEXT_BASED -> R.layout.widget_text_based
                TYPE_MOON_PHASE -> R.layout.widget_moon_phase
                TYPE_HYBRID_CALENDAR -> R.layout.widget_hybrid_calendar
                else -> R.layout.widget_digital_clock
            }
            val views = RemoteViews(context.packageName, layoutId)

            // --- Populate content ---
            if (!hasData) {
                populatePlaceholder(views, widgetType)
            } else {
                val solarDate = prefs.getString("lunar_solar_date", "--/--/----") ?: "--/--/----"
                val lunarDate = prefs.getString("lunar_date", "--/--") ?: "--/--"
                val lunarYear = prefs.getString("lunar_year", "") ?: ""
                val canChiDay = prefs.getString("lunar_can_chi_day", "") ?: ""
                val hoangDao = prefs.getString("lunar_hoang_dao", "") ?: ""

                when (widgetType) {
                    TYPE_HYBRID_CALENDAR -> populateHybrid(
                        views, solarDate, lunarDate, lunarYear, canChiDay, hoangDao,
                        showYear, showZodiac
                    )
                    TYPE_MOON_PHASE -> populateMoonPhase(
                        views, solarDate, lunarDate, lunarYear, canChiDay, hoangDao,
                        showYear, showZodiac
                    )
                    TYPE_TEXT_BASED -> populateTextBased(
                        views, solarDate, lunarDate, lunarYear, canChiDay, hoangDao,
                        showYear, showZodiac
                    )
                    else -> populateDigitalClock(
                        views, solarDate, lunarDate, lunarYear, canChiDay, hoangDao,
                        showYear, showZodiac
                    )
                }
            }

            // --- Apply text color to all common TextViews ---
            applyTextColor(views, textColor, widgetType)

            // --- Apply background ---
            if (bgType == BG_TRANSPARENT) {
                views.setInt(R.id.widget_root, "setBackgroundColor", 0x00000000)
            } else {
                views.setInt(R.id.widget_root, "setBackgroundColor", bgColor)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }

        // ========== Layout population functions ==========

        private fun populatePlaceholder(views: RemoteViews, widgetType: Int) {
            views.setTextViewText(R.id.tv_lunar_date, "Widgetin")
            views.setTextViewText(R.id.tv_solar_date, "")
            if (widgetType != TYPE_HYBRID_CALENDAR) {
                views.setTextViewText(R.id.tv_can_chi, "Mở ứng dụng để thiết lập")
            }
            views.setTextViewText(R.id.tv_hoang_dao, "")
        }

        private fun populateDigitalClock(
            views: RemoteViews,
            solarDate: String, lunarDate: String, lunarYear: String,
            canChiDay: String, hoangDao: String,
            showYear: Boolean, showZodiac: Boolean
        ) {
            views.setTextViewText(R.id.tv_lunar_date, lunarDate)
            views.setTextViewText(R.id.tv_solar_date, solarDate)
            views.setTextViewText(R.id.tv_can_chi, "$lunarYear · $canChiDay")
            views.setTextViewText(R.id.tv_hoang_dao, "Giờ tốt: $hoangDao")
            views.setViewVisibility(R.id.tv_can_chi, if (showYear) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.tv_hoang_dao, if (showZodiac) View.VISIBLE else View.GONE)
        }

        private fun populateTextBased(
            views: RemoteViews,
            solarDate: String, lunarDate: String, lunarYear: String,
            canChiDay: String, hoangDao: String,
            showYear: Boolean, showZodiac: Boolean
        ) {
            views.setTextViewText(R.id.tv_solar_date, solarDate)
            views.setTextViewText(R.id.tv_lunar_date, lunarDate)
            views.setTextViewText(R.id.tv_can_chi, "$lunarYear · $canChiDay")
            views.setTextViewText(R.id.tv_hoang_dao, hoangDao)
            views.setViewVisibility(R.id.tv_can_chi, if (showYear) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.tv_hoang_dao, if (showZodiac) View.VISIBLE else View.GONE)
        }

        private fun populateMoonPhase(
            views: RemoteViews,
            solarDate: String, lunarDate: String, lunarYear: String,
            canChiDay: String, hoangDao: String,
            showYear: Boolean, showZodiac: Boolean
        ) {
            views.setTextViewText(R.id.tv_lunar_date, lunarDate)
            views.setTextViewText(R.id.tv_solar_date, solarDate)
            views.setTextViewText(R.id.tv_can_chi, "$lunarYear · $canChiDay")
            views.setTextViewText(R.id.tv_hoang_dao, "☽ $hoangDao")
            views.setViewVisibility(R.id.tv_can_chi, if (showYear) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.tv_hoang_dao, if (showZodiac) View.VISIBLE else View.GONE)

            // Set moon emoji based on lunar day
            val moonEmoji = getMoonEmoji(lunarDate)
            views.setTextViewText(R.id.tv_moon_icon, moonEmoji)
        }

        private fun populateHybrid(
            views: RemoteViews,
            solarDate: String, lunarDate: String, lunarYear: String,
            canChiDay: String, hoangDao: String,
            showYear: Boolean, showZodiac: Boolean
        ) {
            // Extract lunar day number for the big display
            val lunarDay = lunarDate.split("/").firstOrNull() ?: "--"
            val lunarMonth = lunarDate.split("/").getOrNull(1) ?: "--"

            views.setTextViewText(R.id.tv_lunar_day_big, lunarDay)
            views.setTextViewText(R.id.tv_lunar_month_label, "Tháng $lunarMonth")
            views.setTextViewText(R.id.tv_solar_date, solarDate)
            views.setTextViewText(R.id.tv_can_chi, canChiDay)
            views.setTextViewText(R.id.tv_lunar_date, if (showYear) "Năm $lunarYear" else "")
            views.setTextViewText(R.id.tv_hoang_dao, "Giờ tốt: $hoangDao")
            views.setViewVisibility(R.id.tv_hoang_dao, if (showZodiac) View.VISIBLE else View.GONE)
        }

        // ========== Styling ==========

        private fun applyTextColor(views: RemoteViews, color: Int, widgetType: Int) {
            views.setTextColor(R.id.tv_solar_date, color)
            views.setTextColor(R.id.tv_lunar_date, color)
            views.setTextColor(R.id.tv_hoang_dao, color)

            if (widgetType == TYPE_HYBRID_CALENDAR) {
                views.setTextColor(R.id.tv_lunar_day_big, color)
                views.setTextColor(R.id.tv_lunar_month_label, color)
                views.setTextColor(R.id.tv_can_chi, color)
            } else if (widgetType == TYPE_MOON_PHASE) {
                views.setTextColor(R.id.tv_can_chi, color)
            } else {
                views.setTextColor(R.id.tv_can_chi, color)
            }
        }

        // ========== Helpers ==========

        /** Map lunar day to a moon phase emoji */
        private fun getMoonEmoji(lunarDate: String): String {
            val day = lunarDate.split("/").firstOrNull()?.trim()?.toIntOrNull() ?: 1
            return when {
                day == 1 -> "🌑"
                day <= 7 -> "🌒"
                day <= 9 -> "🌓"
                day <= 14 -> "🌔"
                day == 15 -> "🌕"
                day <= 21 -> "🌖"
                day <= 23 -> "🌗"
                day <= 29 -> "🌘"
                else -> "🌑"
            }
        }

        private fun getIntFromPrefs(
            prefs: SharedPreferences, key: String, default: Int
        ): Int {
            return try {
                prefs.getInt(key, default)
            } catch (e: ClassCastException) {
                try { prefs.getLong(key, default.toLong()).toInt() }
                catch (e2: Exception) { default }
            }
        }

        private fun getColorFromPrefs(
            prefs: SharedPreferences, key: String, default: Int
        ): Int {
            return try {
                prefs.getInt(key, default)
            } catch (e: ClassCastException) {
                try { prefs.getLong(key, default.toLong()).toInt() }
                catch (e2: Exception) { default }
            }
        }
    }
}
