import 'package:flutter/material.dart';

import 'app_button.dart';

/// SUCCESS state: confirmation + next actions.
class SuccessState extends StatelessWidget {
  final VoidCallback onSubmitAnother;
  final VoidCallback onViewReports;

  const SuccessState({
    super.key,
    required this.onSubmitAnother,
    required this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green.shade700),
            const SizedBox(height: 12),
            const Text(
              'Report submitted successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your report was saved (simulated - no database yet).',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                AppButton(
                  label: 'Submit Another',
                  icon: Icons.add,
                  onPressed: onSubmitAnother,
                ),
                AppButton(
                  label: 'View My Reports',
                  icon: Icons.list_alt,
                  outlined: true,
                  onPressed: onViewReports,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
