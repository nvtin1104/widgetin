import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/widget_type.dart';
import '../providers/lunar_calendar_provider.dart';
import '../providers/widget_config_provider.dart';
import '../theme/color_tokens.dart';
import '../widgets/widget_live_preview.dart';

class WidgetEditorScreen extends StatelessWidget {
  const WidgetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'lunar-widget-card',
      child: Scaffold(
        appBar: AppBar(title: const Text('Tùy chỉnh Widget')),
        body: Consumer<WidgetConfigProvider>(
          builder: (context, provider, child) {
            final config = provider.config;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Live preview
                const WidgetLivePreview(),
                const SizedBox(height: 20),

                // --- Layer 1: Widget Type ---
                const _SectionHeader(label: 'Kiểu hiển thị'),
                const SizedBox(height: 8),
                SegmentedButton<WidgetType>(
                  segments: WidgetType.values.map((type) {
                    return ButtonSegment(
                      value: type,
                      label: Text(type.displayName, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  selected: {config.widgetType},
                  onSelectionChanged: (selected) {
                    provider.updateWidgetType(selected.first);
                  },
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 20),

                // --- Layer 2: Background ---
                const _SectionHeader(label: 'Nền'),
                const SizedBox(height: 8),
                SegmentedButton<BackgroundType>(
                  segments: BackgroundType.values.map((type) {
                    return ButtonSegment(
                      value: type,
                      label: Text(type.displayName, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  selected: {config.backgroundType},
                  onSelectionChanged: (selected) {
                    provider.updateBackgroundType(selected.first);
                  },
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 12),

                // Background color
                _ColorPickerTile(
                  label: 'Màu nền',
                  color: config.backgroundColor,
                  onColorChanged: provider.updateBackgroundColor,
                ),

                // Gradient end color (only if gradient)
                if (config.backgroundType == BackgroundType.gradient) ...[
                  _ColorPickerTile(
                    label: 'Màu chuyển',
                    color: config.gradientEndColor,
                    onColorChanged: provider.updateGradientEndColor,
                  ),
                ],

                // Text color
                _ColorPickerTile(
                  label: 'Màu chữ',
                  color: config.textColor,
                  onColorChanged: provider.updateTextColor,
                ),
                const SizedBox(height: 16),

                // --- Layer 2: Typography ---
                const _SectionHeader(label: 'Kiểu chữ'),
                const SizedBox(height: 8),
                SegmentedButton<TypographyStyle>(
                  segments: TypographyStyle.values.map((style) {
                    return ButtonSegment(
                      value: style,
                      label: Text(style.displayName, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  selected: {config.typographyStyle},
                  onSelectionChanged: (selected) {
                    provider.updateTypographyStyle(selected.first);
                  },
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 16),

                // Border radius
                const _SectionHeader(label: 'Bo góc'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: config.borderRadius,
                        min: 0,
                        max: 24,
                        divisions: 24,
                        label: '${config.borderRadius.round()}',
                        onChanged: provider.updateBorderRadius,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${config.borderRadius.round()}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Layer 2: Visibility Toggles ---
                const _SectionHeader(label: 'Hiển thị thông tin'),
                const SizedBox(height: 4),
                SwitchListTile(
                  title: const Text('Năm Can Chi'),
                  value: config.showYearInfo,
                  onChanged: (v) => provider.updateShowYearInfo(v),
                  dense: true,
                ),
                SwitchListTile(
                  title: const Text('Giờ Hoàng Đạo'),
                  value: config.showZodiacHours,
                  onChanged: (v) => provider.updateShowZodiacHours(v),
                  dense: true,
                ),
                SwitchListTile(
                  title: const Text('Tiết khí'),
                  value: config.showSolarTerms,
                  onChanged: (v) => provider.updateShowSolarTerms(v),
                  dense: true,
                ),
                const SizedBox(height: 24),

                // Save button
                _SaveButton(
                  onPressed: () => _saveConfig(context, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveConfig(
    BuildContext context,
    WidgetConfigProvider provider,
  ) async {
    try {
      final lunarDate = context.read<LunarCalendarProvider>().todayLunar;
      await provider.saveConfig(lunarDate: lunarDate);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu cài đặt widget')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorTokens.darkText,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _handleTap,
          icon: const Icon(Icons.save_rounded),
          label: const Text('Lưu & Áp dụng'),
        ),
      ),
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _ColorPickerTile({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorTokens.mutedText.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorTokens.darkText,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: ColorTokens.mutedText, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showColorPicker(BuildContext context) async {
    final pickedColor = await showColorPickerDialog(
      context,
      color,
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.wheel: true,
      },
      enableShadesSelection: true,
      enableOpacity: false,
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: false,
      ),
    );
    onColorChanged(pickedColor);
  }
}
