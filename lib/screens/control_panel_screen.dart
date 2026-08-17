import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../models/app_settings.dart';
import '../models/schedule_status.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';
import '../widgets/countdown_text.dart';
import '../widgets/session_card.dart';
import 'session_form_dialog.dart';

/// شاشة العرض + التحكم الكاملة (رابط التحكم).
class ControlPanelScreen extends StatelessWidget {
  final VoidCallback onLogout;
  const ControlPanelScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kDayNames.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          actions: [
            IconButton(
              tooltip: 'فتح رابط العرض',
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () => context.push('/view'),
            ),
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final d in kDayNames) Tab(text: d)],
          ),
        ),
        body: StreamBuilder<AppSettings>(
          stream: FirestoreService.instance.watchSettings(),
          builder: (context, settingsSnap) {
            if (!settingsSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final settings = settingsSnap.data!;
            return StreamBuilder<List<Session>>(
              stream: FirestoreService.instance.watchSessions(),
              builder: (context, sessionsSnap) {
                final sessions = sessionsSnap.data ?? [];
                return Column(
                  children: [
                    _SettingsBar(settings: settings),
                    if (sessions.isNotEmpty)
                      _LiveStatusStrip(sessions: sessions, campStart: settings.campStartDate),
                    Expanded(
                      child: TabBarView(
                        children: [
                          for (var day = 1; day <= kDayNames.length; day++)
                            _DayEditor(
                              day: day,
                              sessions: sessions.where((s) => s.dayIndex == day).toList()
                                ..sort((a, b) => a.order.compareTo(b.order)),
                              campStart: settings.campStartDate,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SettingsBar extends StatelessWidget {
  final AppSettings settings;
  const _SettingsBar({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 6),
                Text(
                  'بداية المخيم (اليوم الأول): '
                  '${settings.campStartDate.year}-${settings.campStartDate.month.toString().padLeft(2, '0')}-${settings.campStartDate.day.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: settings.campStartDate,
                  firstDate: DateTime(settings.campStartDate.year - 2),
                  lastDate: DateTime(settings.campStartDate.year + 2),
                );
                if (picked != null) {
                  await FirestoreService.instance.setCampStartDate(picked);
                }
              },
              icon: const Icon(Icons.edit_calendar, size: 18),
              label: const Text('تغيير التاريخ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveStatusStrip extends StatelessWidget {
  final List<Session> sessions;
  final DateTime campStart;
  const _LiveStatusStrip({required this.sessions, required this.campStart});

  @override
  Widget build(BuildContext context) {
    final status = ScheduleStatus.compute(sessions, campStart, DateTime.now());
    final theme = Theme.of(context);
    if (status.current == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('لا يوجد برنامج حالياً'),
      );
    }
    final end = status.current!.endDateTime(campStart);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.play_circle_fill, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'الآن: ${status.current!.title}',
              style: theme.textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text('المتبقي', style: theme.textTheme.labelSmall),
          const SizedBox(width: 4),
          CountdownText(
            target: end,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DayEditor extends StatelessWidget {
  final int day;
  final List<Session> sessions;
  final DateTime campStart;
  const _DayEditor({required this.day, required this.sessions, required this.campStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sessions.isEmpty
          ? const Center(child: Text('لا توجد فقرات بعد لهذا اليوم'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88, top: 8),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final s = sessions[index];
                final prev = index > 0 ? sessions[index - 1] : null;
                final next = index < sessions.length - 1 ? sessions[index + 1] : null;
                return SessionListTile(
                  session: s,
                  campStart: campStart,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'تقديم (لأعلى)',
                        icon: const Icon(Icons.arrow_upward, size: 18),
                        onPressed: prev == null
                            ? null
                            : () async {
                                await FirestoreService.instance.setOrder(s.id, prev.order);
                                await FirestoreService.instance.setOrder(prev.id, s.order);
                              },
                      ),
                      IconButton(
                        tooltip: 'تأخير (لأسفل)',
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        onPressed: next == null
                            ? null
                            : () async {
                                await FirestoreService.instance.setOrder(s.id, next.order);
                                await FirestoreService.instance.setOrder(next.id, s.order);
                              },
                      ),
                      IconButton(
                        tooltip: 'تعديل',
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => SessionFormDialog(existing: s),
                        ),
                      ),
                      IconButton(
                        tooltip: 'حذف',
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: Text('هل تريد حذف "${s.title}"؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('إلغاء'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await FirestoreService.instance.deleteSession(s.id);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => SessionFormDialog(existing: s),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final maxOrder = sessions.isEmpty
              ? 0
              : sessions.map((s) => s.order).reduce((a, b) => a > b ? a : b);
          showDialog(
            context: context,
            builder: (_) => SessionFormDialog(
              initialDay: day,
              initialOrder: maxOrder + 10,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة برنامج'),
      ),
    );
  }
}
