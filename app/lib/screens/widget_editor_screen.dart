import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        appBar: AppBar(title: const Text('Customize Widget')),
        body: Consumer<WidgetConfigProvider>(
          builder: (context, provider, child) {
            final config = provider.config;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Live preview with animated container
                const WidgetLivePreview(),
                const SizedBox(height: 24),

                // Background color
                _ColorPickerTile(
                  label: 'Background Color',
                  color: config.backgroundColor,
                  onColorChanged: provider.updateBackgroundColor,
                ),
                const SizedBox(height: 16),

                // Text color
                _ColorPickerTile(
                  label: 'Text Color',
                  color: config.textColor,
                  onColorChanged: provider.updateTextColor,
                ),
                const SizedBox(height: 24),

                // Border radius
                Text(
                  'Border Radius',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ColorTokens.darkText,
                      ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 32),

                // Save button with tap feedback
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
      final lunarDate =
          context.read<LunarCalendarProvider>().todayLunar;
      await provider.saveConfig(lunarDate: lunarDate);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Widget settings saved')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
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
      lowerBound: 0.0,
      upperBound: 1.0,
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
          label: const Text('Save & Apply'),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorTokens.mutedText.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorTokens.darkText,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: ColorTokens.mutedText),
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
