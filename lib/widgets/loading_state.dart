import 'package:flutter/material.dart';

/// LOADING state: progress bar + message while a request is pending.
class LoadingState extends StatelessWidget {
  final String message;

  const LoadingState({
    super.key,
    this.message = 'Submitting your report... (simulated request)',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
      ],
    );
  }
}
