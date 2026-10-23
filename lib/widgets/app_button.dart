import 'package:flutter/material.dart';

/// Shared action button. Reused in Login, Home and ReportFormScreen.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // null = disabled
  final bool isLoading;
  final IconData? icon;
  final bool outlined;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    // Disable the button while loading to prevent duplicate submissions.
    final VoidCallback? effectiveOnPressed = isLoading ? null : onPressed;

    final Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final ButtonStyle style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(140, 48)),
    );

    return outlined
        ? OutlinedButton(
            onPressed: effectiveOnPressed,
            style: style,
            child: child,
          )
        : FilledButton(
            onPressed: effectiveOnPressed,
            style: style,
            child: child,
          );
  }
}
