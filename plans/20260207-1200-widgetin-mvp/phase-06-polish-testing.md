# Phase 06 - Polish & Testing

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** All previous phases (01-05) complete
- **Research:** Both research reports for edge case awareness

## Overview

- **Date:** 2026-02-07
- **Description:** UI polish, animations, edge case handling, manual testing across Android versions, APK optimization, and Play Store preparation.
- **Priority:** P1
- **Implementation Status:** Pending
- **Review Status:** Not started

## Key Insights

- Lunar converter verified 1900-2100 but leap month edge cases need explicit testing
- Vietnam timezone is UTC+7, fixed (no DST); midnight boundary is the key concern
- RemoteViews limitations mean widget polish is constrained; focus app UI polish
- Material You adaptive colors may look different across OEM Android skins
- APK size target: under 15MB for fast download in Vietnamese market

## Requirements

- Smooth page transitions and micro-animations
- Handle leap month display gracefully
- Handle timezone edge case at midnight
- Test on Android API 21, 28, 31, 34 (representative range)
- Optimize APK size (tree-shake, --split-per-abi)
- Create release APK with proper signing
- App icon and splash screen

## Architecture

No new architecture. This phase refines existing code.

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `lib/screens/*.dart` | Modify | Add Hero/page transitions |
| `lib/widgets/*.dart` | Modify | Add implicit animations |
| `lib/services/lunar_calendar_service.dart` | Modify | Timezone guard |
| `android/app/build.gradle` | Modify | Signing config, split APK |
| `android/app/src/main/res/mipmap-*` | Create | App icon assets |
| `pubspec.yaml` | Modify | Add flutter_launcher_icons |

## Implementation Steps

1. **Animations & Transitions**:
   - Add `Hero` animation on widget preview card → editor screen transition
   - Use `AnimatedContainer` for live preview color/radius changes (300ms ease)
   - Add `FadeTransition` on dashboard load
   - Subtle `ScaleTransition` on "Save & Apply" button press feedback

2. **Edge Case Handling**:
   - **Leap month**: When `isLeapMonth == true`, display "Tháng X nhuận" in preview and widget
   - **Midnight boundary**: In `LunarCalendarService.getToday()`, use `DateTime.now().toLocal()` and ensure timezone offset is +7 for Vietnamese calendar correctness
   - **Year boundary**: Test Dec 31 → Jan 1 solar + corresponding lunar year transition
   - **Empty SharedPreferences**: Widget shows placeholder "Open Widgetin to set up" when no data

3. **App Icon & Splash**:
   - Design minimalist icon: calendar symbol with pastel sage green background
   - Add `flutter_launcher_icons` to pubspec, configure for Android adaptive icons
   - Simple splash screen via `flutter_native_splash` or manual `launch_background.xml`

4. **Manual Testing Matrix**:

   | Test Case | API 21 | API 28 | API 31 | API 34 |
   |-----------|--------|--------|--------|--------|
   | App launches | | | | |
   | Dashboard shows lunar data | | | | |
   | Editor color picker works | | | | |
   | Widget appears in picker | | | | |
   | Widget shows correct data | | | | |
   | Config change updates widget | | | | |
   | App restart preserves config | | | | |
   | Reboot preserves widget | | | | |
   | Leap month display | | | | |

5. **APK Optimization**:
   - `flutter build apk --release --split-per-abi` for arm64-v8a + armeabi-v7a
   - Enable R8 minification (`minifyEnabled true` in build.gradle release block)
   - Enable `shrinkResources true`
   - Verify APK size < 15MB per ABI split

6. **Release Signing**:
   - Generate keystore: `keytool -genkey -v -keystore widgetin-release.jks -keyalg RSA -keysize 2048 -validity 10000`
   - Configure `android/key.properties` (gitignored)
   - Reference in `android/app/build.gradle` signingConfigs

7. **Play Store Assets** (prepare, not submit):
   - Screenshots (phone): 1080x1920, dashboard + editor + widget on homescreen
   - Feature graphic: 1024x500
   - Short description (80 chars): "Vietnamese Lunar Calendar widget for your home screen"
   - Full description with keywords: lịch âm, âm lịch, can chi, giờ hoàng đạo

## Todo List

- [ ] Add Hero animation dashboard → editor
- [ ] Add AnimatedContainer to live preview
- [ ] Handle leap month display string
- [ ] Add timezone guard in LunarCalendarService
- [ ] Test year boundary (Dec 31 / Jan 1)
- [ ] Handle empty SharedPreferences in widget
- [ ] Create app icon (adaptive)
- [ ] Add splash screen
- [ ] Run manual test matrix on 4 API levels
- [ ] Build release APK with split-per-abi
- [ ] Configure release signing
- [ ] Verify APK < 15MB
- [ ] Prepare Play Store listing assets

## Success Criteria

- All cells in testing matrix pass
- No crashes or ANRs in 30-min manual testing session
- Leap month and year boundary display correctly
- APK size < 15MB (arm64)
- Release APK installs and runs on physical device
- App icon displays correctly in launcher

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| OEM skin breaks Material You colors | Medium | Test on Samsung + Pixel; fall back to fixed palette |
| R8 strips needed code | Low | Add ProGuard keep rules for home_widget classes |
| Widget blank after reboot | Medium | Ensure onUpdate reads SharedPrefs, not just Flutter push |

## Security Considerations

- **Keystore**: Never commit `widgetin-release.jks` or `key.properties` to git. Add both to `.gitignore`.
- **ProGuard**: Keep rules for reflection-dependent classes.

## Next Steps

MVP complete. Future iterations:
- iOS widget support (WidgetKit + SwiftUI)
- Additional widget types (weather, prayer times)
- Widget themes / presets
- Locale support (English)
- Google Play Store submission
