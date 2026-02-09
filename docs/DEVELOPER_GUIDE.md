# Hướng dẫn Phát triển Widgetin - Hướng Dẫn Toàn Diện

**Phiên bản:** 1.0.0
**Cập nhật lần cuối:** 2026-02-09
**Dành cho:** Lập trình viên Flutter/Dart với kinh nghiệm trung bình trở lên

## Mục Lục

1. [Hướng dẫn Sử dụng](#1-hướng-dẫn-sử-dụng)
2. [Thêm Tính Năng Mới](#2-thêm-tính-năng-mới)
3. [Cơ Chế Flutter & Dart](#3-giải-thích-cơ-chế-hoạt-động-của-flutter--dart)
4. [Xây Dựng Component Mới](#4-cách-xây-dựng-component-mới)

---

## 1. Hướng dẫn Sử dụng

### 1.1 Clone và Chuẩn bị Môi trường

```bash
# Clone repository
git clone https://github.com/your-org/widgetin.git
cd widgetin

# Chuẩn bị ứng dụng (chỉ cần chạy một lần)
cd app
flutter pub get

# Kiểm tra cài đặt (xem phiên bản Flutter, Dart, thiết bị kết nối)
flutter doctor
```

**Yêu cầu:**
- Flutter 3.10.0 hoặc mới hơn
- Dart 3.0.0 hoặc mới hơn
- Android SDK 21+ (minSdk)
- JDK 11+

### 1.2 Cấu Trúc Dự Án

```
widgetin/                                    # Root
├── CLAUDE.md                                # Kiến thức cơ sở dự án (quan trọng!)
├── app/                                     # Ứng dụng Flutter chính
│   ├── lib/
│   │   ├── main.dart                        # Entry point với MultiProvider
│   │   ├── app.dart                         # MaterialApp setup
│   │   ├── models/                          # Dữ liệu models (bất biến)
│   │   │   └── lunar_date.dart              # LunarDate model
│   │   ├── services/                        # Logic kinh doanh
│   │   │   ├── lunar_calendar_service.dart  # Chuyển đổi lịch
│   │   │   └── widget_data_sync_service.dart # Đồng bộ widget
│   │   ├── providers/                       # State management (Provider)
│   │   │   ├── lunar_calendar_provider.dart
│   │   │   └── widget_config_provider.dart
│   │   ├── screens/                         # Các màn hình chính
│   │   │   ├── home_shell.dart              # Shell với NavigationBar
│   │   │   ├── dashboard_screen.dart        # Trang chủ
│   │   │   └── widget_editor_screen.dart    # Bộ chỉnh sửa
│   │   ├── widgets/                         # Widget tái sử dụng
│   │   │   ├── widget_preview_card.dart     # Card hiển thị
│   │   │   ├── lunar_calendar_preview.dart  # Preview dữ liệu âm lịch
│   │   │   └── widget_live_preview.dart     # Preview với animation
│   │   ├── theme/                           # Chủ đề và màu sắc
│   │   │   ├── app_theme.dart               # ThemeData factory
│   │   │   └── color_tokens.dart            # Hằng số màu
│   │   └── utils/                           # Hàm trợ giúp tinh khiết
│   │       ├── can_chi_helper.dart          # Can Chi sexagenary
│   │       └── hoang_dao_helper.dart        # Giờ Hoàng Đạo
│   ├── test/                                # Unit & Widget tests
│   │   ├── widget_test.dart
│   │   ├── providers/
│   │   ├── screens/
│   │   ├── services/
│   │   └── utils/
│   ├── android/                             # Code native Android
│   │   ├── app/build.gradle
│   │   └── app/src/main/
│   │       ├── kotlin/.../LunarCalendarWidget.kt
│   │       ├── res/layout/                  # XML RemoteViews
│   │       ├── res/drawable/                # Drawable resources
│   │       ├── res/xml/                     # AppWidget metadata
│   │       └── AndroidManifest.xml
│   ├── pubspec.yaml                         # Dependencies
│   ├── pubspec.lock                         # Resolved versions
│   └── analysis_options.yaml                # Linting rules
└── plans/20260207-1200-widgetin-mvp/       # Kế hoạch dự án
    ├── plan.md                              # Master plan
    └── phase-*.md                           # Chi tiết từng phase
```

### 1.3 Lệnh Flutter Thường Dùng

```bash
cd app/

# Chạy ứng dụng (device kết nối hoặc emulator)
flutter run

# Chạy trên Chrome (debugging)
flutter run -d chrome

# Chạy với chế độ Release (tối ưu hóa)
flutter run --release

# Chạy tất cả tests (68 tests)
flutter test

# Chạy test với coverage
flutter test --coverage

# Phân tích mã (linting)
flutter analyze

# Xây dựng APK release
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk

# Xây dựng app bundle (Google Play)
flutter build appbundle --release

# Xoá artifacts được cache
flutter clean
```

### 1.4 Chạy Trên Emulator vs Thiết Bị Thực

**Danh sách thiết bị kết nối:**
```bash
flutter devices
```

**Chạy trên emulator Android:**
```bash
# Liệt kê tất cả emulator
emulator -list-avds

# Khởi động emulator
emulator -avd <tên_emulator>

# Chạy flutter trên emulator (tự động phát hiện)
flutter run
```

**Chạy trên thiết bị thực:**
1. Bật Developer Mode trên thiết bị (Android)
2. Kết nối USB và cho phép USB Debugging
3. Chạy `flutter run`

**Gỡ lỗi:**
```bash
# Xem logs
flutter logs

# Kiểm tra kết nối
adb devices

# Cài lại app
flutter install
```

---

## 2. Thêm Tính Năng Mới

### 2.1 Quy Trình Chung

Luôn tuân theo quy trình này khi thêm tính năng:

```
1. Tạo Model (nếu cần) → 2. Tạo Service → 3. Tạo Provider
   ↓
4. Tạo Widget/Màn hình → 5. Viết Tests → 6. Commit
```

### 2.2 Thêm Widget Loại Mới (Ví dụ: Weather Widget)

#### Bước 1: Tạo Model

Tạo file `C:\project\widgetin\app\lib\models\weather_data.dart`:

```dart
class WeatherData {
  final String location;
  final double temperature;
  final String condition;
  final DateTime updatedAt;
  final String canChiDay;

  const WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.updatedAt,
    required this.canChiDay,
  });

  // copyWith pattern cho immutability
  WeatherData copyWith({
    String? location,
    double? temperature,
    String? condition,
    DateTime? updatedAt,
    String? canChiDay,
  }) {
    return WeatherData(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      updatedAt: updatedAt ?? this.updatedAt,
      canChiDay: canChiDay ?? this.canChiDay,
    );
  }

  @override
  String toString() => 'WeatherData($location, ${temperature}°C)';
}
```

#### Bước 2: Tạo Service

Tạo file `C:\project\widgetin\app\lib\services\weather_service.dart`:

```dart
// Service chứa logic kinh doanh pure, không phụ thuộc vào UI
class WeatherService {
  // Lấy dữ liệu thời tiết từ API
  Future<WeatherData> fetchWeather(double latitude, double longitude) async {
    // Gọi API, parse response
    final response = await _httpClient.get(
      'https://api.weather.example.com/current?lat=$latitude&lon=$longitude'
    );

    final data = jsonDecode(response.body);
    final jdn = CanChiHelper.julianDayNumber(DateTime.now());
    final canChiDay = CanChiHelper.getCanChiDay(jdn);

    return WeatherData(
      location: data['name'],
      temperature: data['main']['temp'].toDouble(),
      condition: data['weather'][0]['main'],
      updatedAt: DateTime.now(),
      canChiDay: canChiDay,
    );
  }

  // Validate dữ liệu
  bool isWeatherStale(WeatherData data) {
    final now = DateTime.now();
    return now.difference(data.updatedAt).inMinutes > 30;
  }
}
```

#### Bước 3: Tạo Provider

Tạo file `C:\project\widgetin\app\lib\providers\weather_provider.dart`:

```dart
import 'package:flutter/foundation.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  WeatherData? _currentWeather;
  bool _isLoading = false;
  String? _error;

  // Getters
  WeatherData? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Tải thời tiết
  Future<void> loadWeather(double latitude, double longitude) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentWeather = await _service.fetchWeather(latitude, longitude);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Làm mới dữ liệu
  void refresh() {
    if (_currentWeather != null) {
      if (_service.isWeatherStale(_currentWeather!)) {
        // Tải lại nếu dữ liệu cũ
        loadWeather(0.0, 0.0);
      }
    }
  }
}
```

Đăng ký Provider trong `main.dart`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // ... các provider khác
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
      ],
      child: const WidgetinApp(),
    ),
  );
}
```

#### Bước 4: Tạo Widget Hiển Thị

Tạo file `C:\project\widgetin\app\lib\widgets\weather_preview.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../theme/color_tokens.dart';

// Stateless - nhận dữ liệu từ parent
class WeatherPreview extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherPreview({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Địa điểm
        Text(
          weatherData.location,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Nhiệt độ lớn
        Text(
          '${weatherData.temperature.toStringAsFixed(1)}°C',
          style: textTheme.displaySmall?.copyWith(
            color: ColorTokens.softRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // Điều kiện thời tiết
        Text(
          weatherData.condition,
          style: textTheme.bodyMedium?.copyWith(
            color: ColorTokens.mutedText,
          ),
        ),
        const SizedBox(height: 8),

        // Can Chi
        Text(
          'Năm ${weatherData.canChiDay}',
          style: textTheme.bodySmall?.copyWith(
            color: ColorTokens.softRed,
          ),
        ),
      ],
    );
  }
}
```

#### Bước 5: Thêm Màn Hình Widget

Tạo file `C:\project\widgetin\app\lib\screens\weather_editor_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../theme/color_tokens.dart';
import '../widgets/weather_preview.dart';

class WeatherEditorScreen extends StatelessWidget {
  const WeatherEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Widget')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final weather = provider.currentWeather;

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (weather == null) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                WeatherPreview(weatherData: weather),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: provider.refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Làm mới'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

#### Bước 6: Viết Tests

Tạo file `C:\project\widgetin\app\test\providers\weather_provider_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/models/weather_data.dart';
import 'package:widgetin/providers/weather_provider.dart';

void main() {
  group('WeatherProvider', () {
    test('khởi tạo với trạng thái rỗng', () {
      final provider = WeatherProvider();
      expect(provider.currentWeather, isNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('notifyListeners khi tải thành công', () {
      final provider = WeatherProvider();
      addTearDown(provider.dispose);

      var callCount = 0;
      provider.addListener(() => callCount++);

      // Mock weather data
      final mockWeather = WeatherData(
        location: 'Hà Nội',
        temperature: 25.5,
        condition: 'Mây',
        updatedAt: DateTime.now(),
        canChiDay: 'Giáp Tý',
      );

      // Test: provider nên gọi listener khi load
      // Implement mock service để test
    });
  });
}
```

Tạo file `C:\project\widgetin\app\test\widgets\weather_preview_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/models/weather_data.dart';
import 'package:widgetin/widgets/weather_preview.dart';

void main() {
  group('WeatherPreview Widget', () {
    testWidgets('hiển thị dữ liệu thời tiết chính xác', (tester) async {
      final weatherData = WeatherData(
        location: 'Hà Nội',
        temperature: 28.5,
        condition: 'Nắng',
        updatedAt: DateTime.now(),
        canChiDay: 'Giáp Tý',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPreview(weatherData: weatherData),
          ),
        ),
      );

      expect(find.text('Hà Nội'), findsOneWidget);
      expect(find.text('28.5°C'), findsOneWidget);
      expect(find.text('Nắng'), findsOneWidget);
      expect(find.text('Năm Giáp Tý'), findsOneWidget);
    });
  });
}
```

### 2.3 Thêm Màn Hình Mới

#### Template cho StatelessWidget Screen

```dart
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nội dung
          ],
        ),
      ),
    );
  }
}
```

#### Template cho StatefulWidget Screen (với animations)

```dart
import 'package:flutter/material.dart';

class AnimatedNewScreen extends StatefulWidget {
  const AnimatedNewScreen({super.key});

  @override
  State<AnimatedNewScreen> createState() => _AnimatedNewScreenState();
}

class _AnimatedNewScreenState extends State<AnimatedNewScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Screen')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [],
        ),
      ),
    );
  }
}
```

### 2.4 Thêm Provider Mới

**Bước thêm Provider:**

1. Tạo class extends `ChangeNotifier` trong `lib/providers/`
2. Tạo private properties cho state
3. Thêm public getters
4. Thêm public methods gọi `notifyListeners()`
5. Đăng ký trong `MultiProvider` tại `main.dart`
6. Viết tests trong `test/providers/`

**Ví dụ cấu trúc:**

```dart
class MyProvider extends ChangeNotifier {
  // Private state
  MyData? _data;
  bool _isLoading = false;
  String? _error;

  // Public getters
  MyData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Public methods
  Future<void> loadData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _data = await _service.getData();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _data = null;
      _isLoading = false;
    }
    notifyListeners();
  }
}
```

### 2.5 Thêm Service Mới

Services chứa logic kinh doanh, độc lập với UI:

```dart
class MyService {
  // Hàm static pure - dễ test
  static String formatData(String raw) {
    return raw.toUpperCase();
  }

  // Hoặc phương thức instance nếu cần state
  MyData processData(RawData input) {
    // Logic xử lý
    return MyData(...);
  }
}
```

**Cách dùng:**
- Trong Provider: `_service = MyService()`
- Gọi: `_service.processData(...)`

### 2.6 Quy Ước Đặt Tên và Thư Mục

**File naming:**
```
services/       → service_name.dart (snake_case)
providers/      → provider_name.dart
screens/        → screen_name.dart
models/         → model_name.dart
widgets/        → widget_name.dart
utils/          → utility_name.dart
theme/          → theme_files.dart
```

**Class naming:**
```
ServiceName       (PascalCase)
_PrivateClass     (underbar prefix)
modelName         (camelCase for vars/methods)
MODEL_CONSTANT    (camelCase constants, Dart style)
```

**Test file naming:**
```
services/my_service.dart       → test/services/my_service_test.dart
widgets/my_widget.dart         → test/widgets/my_widget_test.dart
providers/my_provider.dart     → test/providers/my_provider_test.dart
```

### 2.7 Viết Tests cho Tính Năng Mới

**Unit Test Pattern:**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    // Arrange - Chuẩn bị
    test('đôi khi thực hiện hành động X', () {
      final service = MyService();

      // Act - Hành động
      final result = service.doSomething();

      // Assert - Kiểm tra
      expect(result, equals(expectedValue));
    });
  });
}
```

**Widget Test Pattern:**

```dart
testWidgets('Widget hiển thị dữ liệu đúng', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MyWidget(data: testData),
      ),
    ),
  );

  // Act
  await tester.tap(find.byIcon(Icons.button));
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('Expected Text'), findsOneWidget);
});
```

**Chạy tests:**
```bash
flutter test                    # Tất cả tests
flutter test --coverage         # Với coverage report
flutter test test/screens/      # Một thư mục cụ thể
flutter test test/screens/home_test.dart  # Một file cụ thể
```

---

## 3. Giải Thích Cơ Chế Hoạt Động của Flutter & Dart

### 3.1 Widget Tree, Element Tree, RenderObject Tree

Flutter xử lý UI qua 3 lớp cây độc lập:

```
                       Widget Tree (khai báo)
                       ↓
                 Các Widget gọi build()
                       ↓
Immutable                        Mutable          Mutable
const Widget()   →  Element   →  RenderObject   → Layout/Paint
  (Blueprint)     (Instance)      (Geometry)     (Pixel)
```

**Ví dụ:**

```dart
// Widget Tree - chỉ là blueprint bất biến
Container(
  color: Colors.blue,
  child: Text('Hello'),
)

// Element Tree - được tạo từ Container & Text widget
// Giữ state và context, kết nối Widget ↔ RenderObject

// RenderObject Tree - thực hiện layout & paint
// RenderConstrainedBox, RenderBox, v.v.
```

**Khi nào cây cập nhật?**
1. Widget rebuild (setState, notifyListeners)
2. Nếu widget.runtimeType hoặc key khác → Element thay thế
3. RenderObject cập nhật layout/paint

### 3.2 StatelessWidget vs StatefulWidget Lifecycle

#### StatelessWidget

```
StatelessWidget được rebuild khi:
  • Parent rebuild
  • Widget configuration (props) thay đổi

  ┌─────────────────────────────────┐
  │ StatelessWidget                 │
  │ └─ build(context) → Widget      │ (gọi mỗi lần rebuild)
  └─────────────────────────────────┘
```

**Ví dụ:**
```dart
class SimpleWidget extends StatelessWidget {
  final String text;

  const SimpleWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    // Được gọi mỗi lần parent rebuild
    return Text(text);
  }
}

// Sử dụng
SimpleWidget(text: 'Hello')
```

#### StatefulWidget

```
StatefulWidget có internal state & lifecycle:

  ┌─────────────────────────────────────────┐
  │ StatefulWidget                          │
  │   ├─ createState() → State instance     │ (một lần)
  │   └─ State<T>                           │
  │      ├─ initState() → void              │ (khi Element tạo)
  │      ├─ build(context) → Widget         │ (rebuild mỗi setState)
  │      ├─ didUpdateWidget(old) → void     │ (widget config thay)
  │      ├─ dispose() → void                │ (khi Element remove)
  │      └─ setState(() { ... })            │ (trigger rebuild)
  └─────────────────────────────────────────┘
```

**Ví dụ:**
```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    print('Widget khởi tạo');
  }

  @override
  void didUpdateWidget(Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Widget config thay đổi');
  }

  @override
  void dispose() {
    print('Widget hủy');
    super.dispose();
  }

  void _increment() {
    setState(() {
      count++;  // Trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() gọi, count=$count');
    return Text('Count: $count');
  }
}
```

**Khi nào dùng:**
- **StatelessWidget:** Dữ liệu không thay đổi (presentation only)
- **StatefulWidget:** Cần quản lý state cục bộ (animations, form input, v.v.)

### 3.3 Cơ Chế Provider Pattern (ChangeNotifier + Consumer)

Provider là cách chia sẻ state giữa nhiều widget mà không cần prop drilling:

```
                    main.dart
                    ↓
           ┌────────────────────┐
           │  MultiProvider     │
           │  ├─ Provider 1     │
           │  ├─ Provider 2     │
           │  └─ child: App     │
           └────────────────────┘
                    ↓
          (Nested trong BuildContext)
                    ↓
        Widget bất kỳ có thể:
        • context.read<Provider>() (tìm giá trị)
        • context.watch<Provider>() (theo dõi thay đổi)
        • Consumer<Provider>()    (rebuild khi thay đổi)
```

**Luồng hoạt động:**

1. **Tạo Provider:**
```dart
class LunarCalendarProvider extends ChangeNotifier {
  LunarDate? _todayLunar;

  LunarDate? get todayLunar => _todayLunar;

  void loadToday() {
    _todayLunar = _service.getToday();
    notifyListeners();  // Báo tất cả Consumer
  }
}
```

2. **Đăng ký Provider:**
```dart
void main() {
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
```

3. **Sử dụng Provider - Cách 1: Consumer**
```dart
Consumer<LunarCalendarProvider>(
  builder: (context, provider, child) {
    final lunar = provider.todayLunar;
    if (lunar == null) {
      return const CircularProgressIndicator();
    }
    return Text('${lunar.lunarDay}/${lunar.lunarMonth}');
  },
)
```

3. **Sử dụng Provider - Cách 2: context.watch**
```dart
@override
Widget build(BuildContext context) {
  final lunar = context.watch<LunarCalendarProvider>().todayLunar;

  return Text('Lunar: $lunar');  // Rebuild khi provider notify
}
```

3. **Sử dụng Provider - Cách 3: context.read (một lần)**
```dart
ElevatedButton(
  onPressed: () {
    final provider = context.read<LunarCalendarProvider>();
    provider.loadToday();  // Không rebuild từ read
  },
  child: const Text('Load'),
)
```

**Diagram chu kỳ:**
```
User action → setState/notifyListeners → Builder/Consumer gọi lại
                                              ↑
                                         Widget rebuild
```

### 3.4 Cơ Chế home_widget Bridge (Flutter → SharedPrefs → Widget Kotlin)

Cách ứng dụng Flutter truyền dữ liệu tới native home screen widget:

```
      Flutter App (lib/services/widget_data_sync_service.dart)
                    ↓
      HomeWidget.saveWidgetData('key', value)
                    ↓
      Android SharedPreferences (device storage)
      /data/data/com.widgetin.widgetin/shared_prefs/
                    ↓
      Native Widget (Kotlin: LunarCalendarWidget.kt)
      onUpdate() → RemoteViews.setTextViewText('key')
                    ↓
      Home Screen Widget hiển thị
```

**Lưu dữ liệu từ Flutter:**

```dart
// lib/services/widget_data_sync_service.dart
class WidgetDataSyncService {
  static const _androidWidgetName = 'LunarCalendarWidget';

  // Lưu dữ liệu
  static Future<void> syncLunarData(LunarDate lunar) async {
    final solarDate = '${lunar.solarDate.day}/${lunar.solarDate.month}/${lunar.solarDate.year}';

    await Future.wait([
      HomeWidget.saveWidgetData('lunar_solar_date', solarDate),
      HomeWidget.saveWidgetData('lunar_date', '${lunar.lunarDay}/${lunar.lunarMonth}'),
      HomeWidget.saveWidgetData('lunar_year', lunar.canChiYear),
      HomeWidget.saveWidgetData('lunar_can_chi_day', lunar.canChiDay),
    ]);
  }

  // Cập nhật widget (gọi onUpdate)
  static Future<void> updateWidget() async {
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
    );
  }
}
```

**Đọc dữ liệu trong Kotlin:**

```kotlin
// android/app/src/main/kotlin/com/widgetin/widgetin/LunarCalendarWidget.kt
class LunarCalendarWidget : AppWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray
  ) {
    val prefs = context.getSharedPreferences(
        "FlutterSharedPreferences", Context.MODE_PRIVATE
    )

    // Đọc từ SharedPreferences
    val lunarDate = prefs.getString("flutter.lunar_date", "Chưa có dữ liệu")
    val canChiYear = prefs.getString("flutter.lunar_year", "")

    // Cập nhật RemoteViews (UI native)
    val views = RemoteViews(context.packageName, R.layout.lunar_calendar_widget_layout)
    views.setTextViewText(R.id.lunar_date_text, lunarDate)
    views.setTextViewText(R.id.can_chi_year_text, "Năm $canChiYear")

    // Đẩy tới widget trên home screen
    appWidgetManager.updateAppWidget(appWidgetId, views)
  }
}
```

**Chu kỳ cập nhật:**
```
LunarCalendarProvider.loadToday()
    ↓
WidgetDataSyncService.syncLunarData(lunar)
    ↓
HomeWidget.saveWidgetData(...)  → SharedPreferences
    ↓
WidgetDataSyncService.updateWidget()
    ↓
HomeWidget.updateWidget() → gọi LunarCalendarWidget.onUpdate()
    ↓
RemoteViews hiển thị dữ liệu mới trên home screen
```

### 3.5 Pipeline Lịch Âm Lịch

Quy trình chuyển đổi từ ngày dương sang âm lịch với Can Chi và Giờ Hoàng Đạo:

```
DateTime solarDate (ngày dương hôm nay)
    ↓
[1] LunarSolarConverter.solarToLunar() → Lunar calendar
    • Từ lunar_calendar_converter_new package
    • Input: Solar(year, month, day)
    • Output: Lunar(year, month, day, isLeap)
    ↓
[2] CanChiHelper.getCanChiYear/Month/Day()
    • Year Can: (lunarYear + 6) % 10
    • Year Chi: (lunarYear + 8) % 12
    • Formula Can Chi month & day cứ theo quy luật cố định
    ↓
[3] HoangDaoHelper.getHoangDaoHours(dayChiIndex)
    • Tính JDN (Julian Day Number) từ solarDate
    • Lấy Day Chi từ JDN
    • Lookup 6 giờ Hoàng Đạo từ bảng (6 patterns)
    ↓
LunarDate (hoàn toàn dữ liệu: âm/dương, Can Chi, Hoàng Đạo)
    ↓
HomeWidget → Widget trên home screen
```

**Code flow:**

```dart
// lib/services/lunar_calendar_service.dart
LunarDate getLunarDate(DateTime solarDate) {
  // Bước 1: Chuyển đổi lịch
  final solar = Solar(
    solarYear: solarDate.year,
    solarMonth: solarDate.month,
    solarDay: solarDate.day,
  );
  final lunar = LunarSolarConverter.solarToLunar(solar);

  // Bước 2: Tính Can Chi
  final canChiYear = CanChiHelper.getCanChiYear(lunar.lunarYear!);
  final canChiMonth = CanChiHelper.getCanChiMonth(lunar.lunarMonth!, lunar.lunarYear!);
  final jdn = CanChiHelper.julianDayNumber(solarDate);
  final canChiDay = CanChiHelper.getCanChiDay(jdn);

  // Bước 3: Lấy Giờ Hoàng Đạo
  final dayChiIndex = CanChiHelper.getDayChiIndex(jdn);
  final hoangDaoHours = HoangDaoHelper.getHoangDaoHours(dayChiIndex);

  return LunarDate(
    solarDate: solarDate,
    lunarDay: lunar.lunarDay!,
    lunarMonth: lunar.lunarMonth!,
    lunarYear: lunar.lunarYear!,
    isLeapMonth: lunar.isLeap,
    canChiYear: canChiYear,
    canChiMonth: canChiMonth,
    canChiDay: canChiDay,
    hoangDaoHours: hoangDaoHours,
  );
}
```

**Công thức Can Chi:**

```dart
// lib/utils/can_chi_helper.dart
static const List<String> thienCan = [
  'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'
];
static const List<String> diaChi = [
  'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'
];

// Năm
static String getCanChiYear(int lunarYear) {
  final can = thienCan[(lunarYear + 6) % 10];
  final chi = diaChi[(lunarYear + 8) % 12];
  return '$can $chi';
}

// Ngày (dùng JDN - Julian Day Number)
static String getCanChiDay(int jdn) {
  final can = thienCan[(jdn + 9) % 10];
  final chi = diaChi[(jdn + 1) % 12];
  return '$can $chi';
}
```

### 3.6 Cơ Chế Animation (AnimatedContainer, Hero, FadeTransition)

#### AnimatedContainer

`AnimatedContainer` tự động animate giữa giá trị cũ và mới:

```dart
// lib/widgets/widget_live_preview.dart
class WidgetLivePreview extends StatefulWidget {
  const WidgetLivePreview({super.key});

  @override
  State<WidgetLivePreview> createState() => _WidgetLivePreviewState();
}

class _WidgetLivePreviewState extends State<WidgetLivePreview> {
  late Color _bgColor;
  late double _borderRadius;

  @override
  void initState() {
    super.initState();
    final config = context.read<WidgetConfigProvider>().config;
    _bgColor = config.backgroundColor;
    _borderRadius = config.borderRadius;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final config = context.read<WidgetConfigProvider>().config;
    // Animate khi config thay đổi
    setState(() {
      _bgColor = config.backgroundColor;
      _borderRadius = config.borderRadius;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Center(
        child: Text('Preview'),
      ),
    );
  }
}
```

**Cơ chế:**
```
setState { _bgColor = newColor }
    ↓
AnimatedContainer detect thay đổi
    ↓
Tạo Animation từ giá trị cũ → mới
    ↓
Build lại mỗi frame (60 FPS) với giá trị interpolated
    ↓
300ms hoàn tất animation
```

#### Hero Animation

`Hero` tạo animation liền mạch khi navigate:

```dart
// Dashboard → Editor (Hero tag cùng nhau)
// dashboard_screen.dart
Hero(
  tag: 'lunar-widget-card',
  child: WidgetPreviewCard(...),
)

// widget_editor_screen.dart
Hero(
  tag: 'lunar-widget-card',
  child: Scaffold(...),
)
```

**Cơ chế:**
```
User tap card trên Dashboard
    ↓
Navigator.push(MaterialPageRoute)
    ↓
Flutter detect Hero tag giống
    ↓
Tạo animation: từ vị trí/size cũ → vị trí/size mới
    ↓
Transition smooth suốt navigation
```

#### FadeTransition

Animate opacity mượt mà:

```dart
// dashboard_screen.dart
class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();  // Bắt đầu animate từ 0 → 1
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,  // Opacity 0.0 → 1.0
      child: ListView(...),
    );
  }
}
```

**Lifecycle:**
```
initState() → AnimationController tạo
    ↓
forward() → bắt đầu 0 → 1 trong 500ms
    ↓
Mỗi frame: FadeTransition rebuild với opacity mới
    ↓
dispose() → cleanup AnimationController
```

**So sánh animations:**

| Animation | Khi nào dùng | Mã complexity |
|-----------|-------------|---------------|
| AnimatedContainer | Thay đổi property (color, size) | Thấp |
| Hero | Navigate giữa screens | Thấp (Flutter tự handle) |
| FadeTransition | Fade in/out opacity | Trung bình (cần Controller) |
| ScaleTransition | Scale effect | Trung bình |
| SlideTransition | Slide positioning | Trung bình |
| CustomAnimation | Tuỳ chỉnh phức tạp | Cao |

---

## 4. Cách Xây Dựng Component Mới

### 4.1 Tạo StatelessWidget (Presentation Widget)

**Quy trình:**

```
1. Xác định props (dữ liệu input)
2. Viết build() → return Widget tree
3. Dùng Theme.of(context) cho styling
4. Test với widget test
```

**Template:**

```dart
// lib/widgets/my_widget.dart
import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';

class MyWidget extends StatelessWidget {
  // Props (final, const constructor)
  final String title;
  final String description;
  final VoidCallback? onTap;

  const MyWidget({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy theme
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Build widget tree
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorTokens.darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: ColorTokens.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Sử dụng:**
```dart
MyWidget(
  title: 'Tiêu đề',
  description: 'Mô tả widget',
  onTap: () => print('Tapped'),
)
```

### 4.2 Tạo StatefulWidget với Animation

**Quy trình:**

```
1. Extends StatefulWidget
2. Tạo State class với SingleTickerProviderStateMixin
3. initState() → tạo AnimationController
4. build() → dùng Animated* widget
5. dispose() → cleanup controller
```

**Template:**

```dart
// lib/widgets/animated_widget.dart
import 'package:flutter/material.dart';

class AnimatedMyWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedMyWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedMyWidget> createState() => _AnimatedMyWidgetState();
}

class _AnimatedMyWidgetState extends State<AnimatedMyWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Tạo controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Tạo animations
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Bắt đầu animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
```

### 4.3 Tạo Reusable Card Component

**Ví dụ từ project:**

```dart
// lib/widgets/widget_preview_card.dart
class WidgetPreviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget preview;
  final VoidCallback? onCustomize;

  const WidgetPreviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.preview,
    this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, color: ColorTokens.softRed, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.titleMedium),
                      Text(subtitle, style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preview
            preview,
            const SizedBox(height: 16),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCustomize,
                child: const Text('Customize'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Sử dụng:**
```dart
WidgetPreviewCard(
  icon: Icons.calendar_month_rounded,
  title: 'Âm Lịch',
  subtitle: 'Vietnamese Lunar Calendar',
  preview: LunarCalendarPreview(lunarDate: lunar),
  onCustomize: () => Navigator.push(...),
)
```

**Lợi ích:**
- Reusable cho multiple widget types
- Consistent styling
- Dễ maintain

### 4.4 Sử Dụng Theme Tokens và Color Tokens

**Color Tokens:**

```dart
// lib/theme/color_tokens.dart
class ColorTokens {
  ColorTokens._();  // Private constructor

  static const Color softRed = Color(0xFFE8998D);
  static const Color cream = Color(0xFFFAF8F3);
  static const Color sageGreen = Color(0xFFC4DDC4);
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color mutedText = Color(0xFF8B8B8B);
}
```

**Theme Setup:**

```dart
// lib/theme/app_theme.dart
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ColorTokens.sageGreen,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ColorTokens.cream,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: ColorTokens.darkText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(color: ColorTokens.darkText),
        bodyMedium: TextStyle(color: ColorTokens.mutedText),
      ),
    );
  }
}
```

**Dùng trong Widget:**

```dart
@override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Text(
    'Hello',
    style: textTheme.titleMedium?.copyWith(
      color: ColorTokens.softRed,  // Token
      fontWeight: FontWeight.bold,
    ),
  );
}
```

**Lợi ích:**
- Centralized color management
- Dễ thay đổi theme toàn ứng dụng
- Consistent branding

### 4.5 Tích hợp với Provider cho Reactive Updates

**Pattern: Consumer → rebuild khi data thay đổi**

```dart
import 'package:provider/provider.dart';
import '../providers/my_provider.dart';

class MyConsumerWidget extends StatelessWidget {
  const MyConsumerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, child) {
        // Rebuild mỗi khi provider notify
        if (provider.isLoading) {
          return const CircularProgressIndicator();
        }

        if (provider.error != null) {
          return Text('Error: ${provider.error}');
        }

        final data = provider.data;
        return ListView(
          children: data?.map((item) => _buildItem(item)).toList() ?? [],
        );
      },
    );
  }

  Widget _buildItem(Item item) {
    return ListTile(title: Text(item.title));
  }
}
```

**Pattern: watch → trong build method**

```dart
@override
Widget build(BuildContext context) {
  // watch = rebuild khi thay đổi
  final data = context.watch<MyProvider>().data;

  // read = lấy giá trị (không rebuild)
  final provider = context.read<MyProvider>();

  return Text(data.toString());
}
```

**Pattern: select → rebuild chỉ khi property cụ thể thay đổi**

```dart
// Chỉ rebuild khi isLoading thay đổi, không quan tâm data
final isLoading = context.select<MyProvider, bool>(
  (provider) => provider.isLoading,
);

return isLoading
    ? const CircularProgressIndicator()
    : const SizedBox();
```

---

## Tổng Kết

| Khía cạnh | Quy tắc chính |
|----------|--------------|
| **Architecture** | Model → Service → Provider → Widget |
| **State Management** | Provider + ChangeNotifier, notify khi change |
| **UI Layout** | Widget tree, theme tokens, Material Design 3 |
| **Animation** | AnimationController, Tween, Curves |
| **Testing** | Unit test cho service, widget test cho UI |
| **Code Style** | Immutable models, snake_case files, PascalCase classes |
| **Android Bridge** | SharedPreferences via HomeWidget package |
| **Vietnamese Domain** | Âm lịch, Can Chi, Giờ Hoàng Đạo |

---

## Tài Liệu Tham Khảo

- **Flutter Docs:** https://flutter.dev/docs
- **Dart Language:** https://dart.dev/guides
- **Provider Package:** https://pub.dev/packages/provider
- **HomeWidget:** https://pub.dev/packages/home_widget
- **Material Design 3:** https://m3.material.io
- **Lunar Calendar Logic:** `lunar_calendar_converter_new` package

---

**Ngày cập nhật:** 2026-02-09
**Bản phát hành:** 1.0.0
**Tác giả:** Đội phát triển Widgetin
