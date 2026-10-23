import 'package:flutter/material.dart';

import 'app_button.dart';

/// ERROR state: clear failure message + Retry action.
class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const ErrorState({
    super.key,
    required this.onRetry,
    this.message =
        'We could not send your report (simulated failure). '
        'Retry, or turn off "Simulate failure" and try again.',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 8),
            const Text(
              'Submission failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            AppButton(label: 'Retry', icon: Icons.refresh, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
