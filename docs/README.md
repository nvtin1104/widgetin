# Widgetin Documentation Hub

Welcome to the Widgetin project documentation. This directory contains comprehensive guides for developers working on the Vietnamese Lunar Calendar widget application.

**Project:** Widgetin ("Widget I Need") - Flutter application for creating Vietnamese home screen widgets
**Version:** 1.0.0
**Last Updated:** 2026-02-09

---

## Documentation Files

### 1. DEVELOPER_GUIDE.md (Main Reference)
**Vietnamese Comprehensive Developer Guide**

The primary reference document for all Widgetin developers. Written entirely in Vietnamese for maximum clarity.

**Contains:**
- Complete setup and installation instructions
- Project structure overview with 70+ file mappings
- Flutter command reference
- Step-by-step feature development guide
- Weather widget implementation example
- Flutter & Dart architecture explanations
- Widget lifecycle and state management
- Provider pattern deep dive
- HomeWidget bridge architecture
- Lunar calendar pipeline explanation
- Animation mechanisms (AnimatedContainer, Hero, FadeTransition)
- Component building patterns
- Theme and color token usage
- Testing strategies

**Best For:**
- New developers joining the project (start with Section 1)
- Understanding Flutter architecture (Section 3)
- Implementing new features (Section 2)
- Building reusable components (Section 4)

**Access:** [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)

**Sections:**
1. **Hướng dẫn Sử dụng** (Usage Guide)
   - Setup, commands, project structure, emulator vs device

2. **Thêm Tính Năng Mới** (Adding Features)
   - General process, weather widget example, services, providers, screens, testing

3. **Cơ Chế Flutter & Dart** (Flutter & Dart Mechanics)
   - Widget trees, StatefulWidget lifecycle, Provider pattern, HomeWidget bridge, lunar calendar pipeline, animations

4. **Xây Dựng Component Mới** (Building Components)
   - StatelessWidget, StatefulWidget with animations, card components, theme tokens, Provider integration

---

### 2. DOCUMENTATION_SUMMARY.md (This Guide Overview)
**Completion Report and Quick Reference**

A summary document describing what's included in the developer guide and how to use it effectively.

**Contains:**
- Document structure breakdown
- Code examples inventory (50+ examples from codebase)
- Technical topics covered
- Document statistics and metrics
- Quality assurance verification
- Integration guidelines
- Maintenance recommendations

**Best For:**
- Quick overview of available documentation
- Finding specific topics
- Understanding document organization
- Quality verification

**Access:** [DOCUMENTATION_SUMMARY.md](./DOCUMENTATION_SUMMARY.md)

---

## Quick Navigation

### Getting Started (New Developer)
1. Read: [DEVELOPER_GUIDE.md - Section 1.1](./DEVELOPER_GUIDE.md#11-clone-và-chuẩn-bị-môi-trường) (Clone & Setup)
2. Read: [DEVELOPER_GUIDE.md - Section 1.2](./DEVELOPER_GUIDE.md#12-cấu-trúc-dự-án) (Project Structure)
3. Run: `cd app && flutter pub get && flutter doctor`
4. Read: [DEVELOPER_GUIDE.md - Section 3](./DEVELOPER_GUIDE.md#3-giải-thích-cơ-chế-hoạt-động-của-flutter--dart) (How Flutter Works)

### Implementing a Feature
1. Follow: [DEVELOPER_GUIDE.md - Section 2.1](./DEVELOPER_GUIDE.md#21-quy-trình-chung) (General Process)
2. Reference: [DEVELOPER_GUIDE.md - Section 2.2](./DEVELOPER_GUIDE.md#22-thêm-widget-loại-mới-ví-dụ-weather-widget) (Feature Example)
3. Use: [DEVELOPER_GUIDE.md - Section 2.6](./DEVELOPER_GUIDE.md#26-quy-ước-đặt-tên-và-thư-mục) (Naming Conventions)
4. Test: [DEVELOPER_GUIDE.md - Section 2.7](./DEVELOPER_GUIDE.md#27-viết-tests-cho-tính-năng-mới) (Testing)

### Building UI Components
1. Learn: [DEVELOPER_GUIDE.md - Section 3.1-3.2](./DEVELOPER_GUIDE.md#31-widget-tree-element-tree-renderobject-tree) (Widget Basics)
2. Reference: [DEVELOPER_GUIDE.md - Section 4.1-4.2](./DEVELOPER_GUIDE.md#41-tạo-statelesswidget-presentation-widget) (Widget Templates)
3. Style: [DEVELOPER_GUIDE.md - Section 4.4](./DEVELOPER_GUIDE.md#44-sử-dụng-theme-tokens-và-color-tokens) (Theme & Colors)
4. Animate: [DEVELOPER_GUIDE.md - Section 3.6](./DEVELOPER_GUIDE.md#36-cơ-chế-animation-animatedcontainer-hero-fadetransition) (Animations)

### State Management
1. Understand: [DEVELOPER_GUIDE.md - Section 3.3](./DEVELOPER_GUIDE.md#33-cơ-chế-provider-pattern-changenotifier--consumer) (Provider Pattern)
2. Implement: [DEVELOPER_GUIDE.md - Section 2.4](./DEVELOPER_GUIDE.md#24-thêm-provider-mới) (Adding Provider)
3. Integrate: [DEVELOPER_GUIDE.md - Section 4.5](./DEVELOPER_GUIDE.md#45-tích-hợp-với-provider-cho-reactive-updates) (Component Integration)

### Android Integration
1. Learn: [DEVELOPER_GUIDE.md - Section 3.4](./DEVELOPER_GUIDE.md#34-cơ-chế-home_widget-bridge-flutter--sharedprefs--widget-kotlin) (HomeWidget Bridge)
2. Reference: [DEVELOPER_GUIDE.md - Section 3.5](./DEVELOPER_GUIDE.md#35-pipeline-lịch-âm-lịch) (Lunar Calendar Pipeline)

---

## Key Concepts

### Architecture
**Model → Service → Provider → Widget**
- Models: Immutable data classes with copyWith()
- Services: Business logic, pure functions
- Providers: State management with ChangeNotifier
- Widgets: UI components, presentation only

### Design System
- **Material You:** ColorScheme.fromSeed() with material3 enabled
- **Color Tokens:** Pastel palette (softRed, cream, sageGreen, darkText, mutedText)
- **Theme:** Centralized in app_theme.dart

### State Management
- **Provider:** Package for reactive state
- **ChangeNotifier:** Base class for providers
- **Consumer:** Widget to rebuild on notification
- **watch/read:** Context methods for access

### Testing
- **Unit Tests:** Services and utility functions
- **Widget Tests:** UI components and screens
- **Pattern:** Arrange-Act-Assert (AAA)

### Vietnamese Domain
- **Âm Lịch:** Lunar calendar (solar ↔ lunar conversion)
- **Can Chi:** Sexagenary cycle (10 stems + 12 branches)
- **Giờ Hoàng Đạo:** 6 auspicious hours per day
- **Nhuận:** Leap month indicator

---

## Quick Reference Tables

### Flutter Commands
```bash
flutter run              # Run app
flutter test             # Run all tests
flutter analyze          # Linting
flutter build apk        # Build release APK
flutter clean            # Clear artifacts
```

### Key Dependencies
```yaml
provider: ^6.1.0                    # State management
home_widget: ^0.9.0                 # Android widget bridge
lunar_calendar_converter_new: ^2.0.0 # Lunar conversion
shared_preferences: ^2.2.0          # Local storage
flex_color_picker: ^3.3.0           # Color picker UI
```

### File Organization
```
lib/
├── models/          # Immutable data classes
├── services/        # Business logic
├── providers/       # State management
├── screens/         # Full-screen pages
├── widgets/         # Reusable components
├── theme/           # Design system
└── utils/           # Pure helper functions
```

---

## Maintenance & Updates

### When to Update Documentation
- When adding a new feature
- When changing architecture pattern
- When updating dependencies
- When fixing bugs with lessons learned
- Quarterly review (every 3 months)

### How to Update
1. Edit the relevant section in DEVELOPER_GUIDE.md
2. Update version number and date
3. Add entry to table of contents if new section
4. Test all code examples
5. Get review from team lead
6. Commit to git

### Reporting Issues
If you find:
- **Inaccuracies:** The guide doesn't match actual code
- **Missing Topics:** Important information not covered
- **Unclear Sections:** Confusing explanations
- **Broken Examples:** Code examples that don't work

Please create an issue or contact the documentation team.

---

## Related Documentation

**In Repository:**
- `CLAUDE.md` - Project knowledge base (AI agent reference)
- `gemini.md` - Gemini agent knowledge base
- `agent.md` - Universal agent guidelines
- `plans/20260207-1200-widgetin-mvp/` - Project phases and planning

**External Resources:**
- [Flutter Official Docs](https://flutter.dev)
- [Dart Language Guide](https://dart.dev)
- [Provider Package Docs](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io)

---

## Document Statistics

| Metric | Value |
|--------|-------|
| **Main Guide Size** | 45.9 KB |
| **Total Sections** | 4 major + 20+ subsections |
| **Code Examples** | 50+ real examples from codebase |
| **Total Words** | 15,000+ |
| **Language** | 100% Vietnamese |
| **Created** | 2026-02-09 |
| **Current Version** | 1.0.0 |

---

## Document Versions

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-09 | Initial creation with 4 main sections |

---

## Accessibility

**For Screen Readers:**
- All sections have clear hierarchy (H1, H2, H3)
- Code blocks are properly marked with language identifier
- Tables have headers and alt descriptions
- Links use descriptive text

**Available Formats:**
- GitHub markdown (default)
- HTML (viewable in browser)
- PDF (printable version, if needed)

---

## Contact & Support

For questions about this documentation:
1. Check the specific section in DEVELOPER_GUIDE.md
2. Search for keywords using Ctrl+F
3. Review the DOCUMENTATION_SUMMARY.md for quick overview
4. Contact the documentation team or project lead

---

## License

This documentation is part of the Widgetin project and follows the same license as the main codebase.

---

**Last Updated:** 2026-02-09
**Maintained By:** Widgetin Documentation Team
**Status:** Complete and Ready for Use ✓
