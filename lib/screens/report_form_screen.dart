import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';
import '../widgets/success_state.dart';

/// The UI states demonstrated in Activity 9.
enum ReportUiState { idle, loading, success, empty, error }

/// Simple in-memory report record (SIMULATED - no database yet).
class Report {
  final String title;
  final String category;
  final String description;
  final DateTime createdAt;

  Report({
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
  });
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const _categories = [
    'Incident',
    'Maintenance',
    'Complaint',
    'Suggestion',
  ];
  String _category = _categories.first;

  ReportUiState _uiState = ReportUiState.idle;
  bool _showReports =
      false; // false = "New Report" tab, true = "My Reports" tab
  bool _simulateFailure = false; // demo switch to trigger the Error state
  final List<Report> _reports = []; // starts empty -> Empty state

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- logic

  Future<void> _submitReport() async {
    if (_uiState == ReportUiState.loading) return; // block duplicates
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _uiState = ReportUiState.loading);

    try {
      // SIMULATED network request (replace with REST API call later).
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_simulateFailure) throw Exception('Simulated failure');
      if (!mounted) return;

      _reports.insert(
        0,
        Report(
          title: _titleController.text.trim(),
          category: _category,
          description: _descriptionController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
      setState(() => _uiState = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  void _resetForm() {
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _category = _categories.first;
      _uiState = ReportUiState.idle;
    });
  }

  void _switchView(bool showReports) {
    setState(() {
      _showReports = showReports;
      if (showReports) {
        _uiState = _reports.isEmpty ? ReportUiState.empty : ReportUiState.idle;
      } else if (_uiState == ReportUiState.empty) {
        _uiState = ReportUiState.idle;
      }
    });
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('New Report'),
                      icon: Icon(Icons.edit_note),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('My Reports'),
                      icon: Icon(Icons.list_alt),
                    ),
                  ],
                  selected: {_showReports},
                  onSelectionChanged: (s) => _switchView(s.first),
                ),
                const SizedBox(height: 24),
                _showReports ? _buildReportsView() : _buildNewReportView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewReportView() {
    // SUCCESS
    if (_uiState == ReportUiState.success) {
      return SuccessState(
        onSubmitAnother: _resetForm,
        onViewReports: () {
          _resetForm();
          _switchView(true);
        },
      );
    }

    final isLoading = _uiState == ReportUiState.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ERROR
        if (_uiState == ReportUiState.error) ...[
          ErrorState(onRetry: _submitReport),
          const SizedBox(height: 16),
        ],
        // LOADING
        if (isLoading) const LoadingState(),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Report Title',
                controller: _titleController,
                enabled: !isLoading,
                validator: (v) {
                  final msg = _required(v, 'Title');
                  if (msg != null) return msg;
                  if (v!.trim().length < 5)
                    return 'Title must be at least 5 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
                enabled: !isLoading,
                validator: (v) {
                  final msg = _required(v, 'Description');
                  if (msg != null) {
                    return msg;
                  }
                  if (v!.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsView() {
    // EMPTY
    if (_uiState == ReportUiState.empty || _reports.isEmpty) {
      return EmptyState(onCreate: () => _switchView(false));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final r in _reports)
          Card(
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(r.title),
              subtitle: Text(
                '${r.category} - ${r.description}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                '${r.createdAt.hour.toString().padLeft(2, '0')}:'
                '${r.createdAt.minute.toString().padLeft(2, '0')}',
              ),
            ),
          ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Clear All (demo)',
          icon: Icons.delete_outline,
          outlined: true,
          onPressed: () {
            setState(() {
              _reports.clear();
              _uiState = ReportUiState.empty;
            });
          },
        ),
      ],
    );
  }
}
