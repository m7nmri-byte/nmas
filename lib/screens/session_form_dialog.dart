import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';

/// نموذج إضافة/تعديل فقرة برنامج.
class SessionFormDialog extends StatefulWidget {
  final Session? existing;
  final int? initialDay;
  final int? initialOrder;

  const SessionFormDialog({
    super.key,
    this.existing,
    this.initialDay,
    this.initialOrder,
  });

  @override
  State<SessionFormDialog> createState() => _SessionFormDialogState();
}

class _SessionFormDialogState extends State<SessionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _dayIndex;
  late TextEditingController _title;
  late TextEditingController _venue;
  late TextEditingController _responsible;
  late TextEditingController _notes;
  late TextEditingController _order;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 0);
  bool _endsNextDay = false;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _dayIndex = e?.dayIndex ?? widget.initialDay ?? 1;
    _title = TextEditingController(text: e?.title ?? '');
    _venue = TextEditingController(text: e?.venue ?? '');
    _responsible = TextEditingController(text: e?.responsible ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _order = TextEditingController(
      text: (e?.order ?? widget.initialOrder ?? 0).toString(),
    );
    if (e != null) {
      _startTime = _parseTime(e.startTime);
      _endTime = _parseTime(e.endTime);
      _endsNextDay = e.endsNextDay;
    }
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );
  }

  String _formatTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _title.dispose();
    _venue.dispose();
    _responsible.dispose();
    _notes.dispose();
    _order.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final session = Session(
      id: widget.existing?.id ?? '',
      dayIndex: _dayIndex,
      dayName: kDayNames[_dayIndex - 1],
      order: int.tryParse(_order.text) ?? 0,
      title: _title.text.trim(),
      venue: _venue.text.trim(),
      responsible: _responsible.text.trim(),
      startTime: _formatTimeOfDay(_startTime),
      endTime: _formatTimeOfDay(_endTime),
      endsNextDay: _endsNextDay,
      notes: _notes.text.trim(),
    );
    if (_isEdit) {
      await FirestoreService.instance.updateSession(session);
    } else {
      await FirestoreService.instance.addSession(session);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'تعديل برنامج' : 'إضافة برنامج'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: _dayIndex,
                  decoration: const InputDecoration(labelText: 'اليوم'),
                  items: [
                    for (var i = 0; i < kDayNames.length; i++)
                      DropdownMenuItem(value: i + 1, child: Text(kDayNames[i])),
                  ],
                  onChanged: (v) => setState(() => _dayIndex = v ?? _dayIndex),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'البرنامج (العنوان)'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _venue,
                  decoration: const InputDecoration(labelText: 'المقر'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _responsible,
                  decoration: const InputDecoration(labelText: 'المكلف'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(true),
                        child: Text('من: ${_formatTimeOfDay(_startTime)}',
                            textDirection: TextDirection.ltr),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(false),
                        child: Text('إلى: ${_formatTimeOfDay(_endTime)}',
                            textDirection: TextDirection.ltr),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _endsNextDay,
                  onChanged: (v) => setState(() => _endsNextDay = v ?? false),
                  title: const Text('ينتهي بعد منتصف الليل (يمتد لليوم التالي)'),
                ),
                TextFormField(
                  controller: _order,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'الترتيب داخل اليوم (رقم)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'تفاصيل إضافية'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('حفظ'),
        ),
      ],
    );
  }
}
