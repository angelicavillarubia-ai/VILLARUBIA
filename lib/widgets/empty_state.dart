import 'package:flutter/material.dart';

import 'app_button.dart';

/// EMPTY state: no data available (this is NOT an error).
class EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const EmptyState({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            const Text(
              'No reports yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have not submitted any reports. Create your first one.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Create a Report',
              icon: Icons.add,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}
