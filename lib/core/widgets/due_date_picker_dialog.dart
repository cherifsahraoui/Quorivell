import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';

/// User confirmed a due date choice (including explicitly clearing it).
class DueDatePickerResult {
  const DueDatePickerResult(this.dueDate);

  final DateTime? dueDate;
}

/// Shows a dialog to optionally set a due date and time for a commitment.
///
/// Returns [DueDatePickerResult] when the user saves, or `null` on cancel.
Future<DueDatePickerResult?> showDueDatePicker({
  required BuildContext context,
  DateTime? initialDate,
}) async {
  return showDialog<DueDatePickerResult>(
    context: context,
    builder: (context) => _DueDatePickerDialog(initialDate: initialDate),
  );
}

class _DueDatePickerDialog extends StatefulWidget {
  const _DueDatePickerDialog({this.initialDate});

  final DateTime? initialDate;

  @override
  State<_DueDatePickerDialog> createState() => _DueDatePickerDialogState();
}

class _DueDatePickerDialogState extends State<_DueDatePickerDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      final initial = widget.initialDate!.toLocal();
      _selectedDate = DateTime(initial.year, initial.month, initial.day);
      _selectedTime = TimeOfDay.fromDateTime(initial);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  DateTime? get _combinedDateTime {
    if (_selectedDate == null) return null;
    final time = _selectedTime;
    if (time == null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      ).toUtc();
    }
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      time.hour,
      time.minute,
    ).toUtc();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(l10n.reviewDueDateDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _selectedDate == null
                  ? l10n.reviewDueDateDialogDateLabel
                  : DateFormat.yMMMd().format(_selectedDate!),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: _selectedDate == null ? null : _pickTime,
            icon: const Icon(Icons.access_time),
            label: Text(
              _selectedTime == null
                  ? l10n.reviewDueDateDialogTimeLabel
                  : _selectedTime!.format(context),
            ),
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                  _selectedTime = null;
                });
              },
              icon: Icon(Icons.clear, color: colorScheme.error),
              label: Text(
                l10n.reviewDueDateDialogClear,
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.reviewDueDateDialogCancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(DueDatePickerResult(_combinedDateTime)),
          child: Text(l10n.reviewDueDateDialogSave),
        ),
      ],
    );
  }
}
