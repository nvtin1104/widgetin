import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/widget_config_provider.dart';
import '../theme/color_tokens.dart';
import '../widgets/widget_live_preview.dart';

class WidgetEditorScreen extends StatelessWidget {
  const WidgetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customize Widget')),
      body: Consumer<WidgetConfigProvider>(
        builder: (context, provider, child) {
          final config = provider.config;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Live preview
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

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _saveConfig(context, provider),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save & Apply'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveConfig(
    BuildContext context,
    WidgetConfigProvider provider,
  ) async {
    try {
      await provider.saveConfig();
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
