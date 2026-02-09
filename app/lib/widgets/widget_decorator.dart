import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/widget_type.dart';

/// Layer 2 Decorator: wraps any Layer 1 view with background + styling
class WidgetDecorator extends StatelessWidget {
  final Widget child;
  final WidgetConfig config;

  const WidgetDecorator({
    super.key,
    required this.child,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: _buildDecoration(),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  BoxDecoration _buildDecoration() {
    switch (config.backgroundType) {
      case BackgroundType.solid:
        return BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(config.borderRadius),
          border: Border.all(
            color: config.textColor.withValues(alpha: 0.12),
          ),
        );
      case BackgroundType.gradient:
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [config.backgroundColor, config.gradientEndColor],
          ),
          borderRadius: BorderRadius.circular(config.borderRadius),
          border: Border.all(
            color: config.textColor.withValues(alpha: 0.12),
          ),
        );
      case BackgroundType.transparent:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(config.borderRadius),
        );
    }
  }
}
