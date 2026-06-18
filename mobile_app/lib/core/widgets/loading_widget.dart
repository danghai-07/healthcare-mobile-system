import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_card.dart';

/// Loading indicator modes for async UI states.
enum LoadingWidgetMode {
  /// Small inline spinner.
  inline,

  /// Centered page-level loader with optional message.
  page,

  /// Full-screen overlay with dimmed backdrop.
  overlay,
}

/// Reusable loading indicator aligned with the healthcare design system.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.mode = LoadingWidgetMode.page,
    this.size = 32,
  });

  const LoadingWidget.inline({
    super.key,
    this.size = 24,
  })  : message = null,
        mode = LoadingWidgetMode.inline;

  const LoadingWidget.overlay({
    super.key,
    this.message,
    this.size = 32,
  }) : mode = LoadingWidgetMode.overlay;

  final String? message;
  final LoadingWidgetMode mode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      LoadingWidgetMode.inline => SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(strokeWidth: 2.5),
        ),
      LoadingWidgetMode.page => Center(child: _LoadingBody(message: message)),
      LoadingWidgetMode.overlay => ColoredBox(
          color: AppColors.scrim.withValues(alpha: 0.25),
          child: Center(child: _LoadingBody(message: message)),
        ),
    };
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Wraps [child] with an overlay [LoadingWidget] when [isLoading] is true.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: LoadingWidget.overlay(message: message),
          ),
      ],
    );
  }
}
