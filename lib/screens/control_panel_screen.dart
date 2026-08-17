import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../models/app_settings.dart';
import '../models/schedule_status.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';
import '../theme.dart';
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
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'فتح رابط العرض',
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () => context.push('/view'),
            ),
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout_rounded),
              onPressed: onLogout,
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  isScrollable: false,
                  tabs: [for (final d in kDayNames) Tab(text: d)],
                ),
              ),
            ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 14,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Text('بداية المخيم: ', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '${settings.campStartDate.year}-${settings.campStartDate.month.toString().padLeft(2, '0')}-${settings.campStartDate.day.toString().padLeft(2, '0')}',
                style: AppTheme.mono(fontSize: 13.5, fontWeight: FontWeight.w700),
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
            icon: const Icon(Icons.edit_calendar_rounded, size: 16),
            label: const Text('تغيير التاريخ'),
          ),
        ],
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
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outline),
        ),
        child: Text('لا يوجد برنامج حالياً', style: theme.textTheme.bodyMedium),
      );
    }
    final end = status.current!.endDateTime(campStart);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              status.current!.title,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text('المتبقي', style: theme.textTheme.labelMedium),
          const SizedBox(width: 6),
          CountdownText(
            target: end,
            style: AppTheme.mono(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.gold),
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
      backgroundColor: Colors.transparent,
      body: sessions.isEmpty
          ? const Center(child: Text('لا توجد فقرات بعد لهذا اليوم'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final s = sessions[index];
                final prev = index > 0 ? sessions[index - 1] : null;
                final next = index < sessions.length - 1 ? sessions[index + 1] : null;
                return SessionListTile(
                  session: s,
                  campStart: campStart,
                  isLast: index == sessions.length - 1,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionIcon(
                        Icons.arrow_upward_rounded,
                        'تقديم',
                        prev == null
                            ? null
                            : () async {
                                await FirestoreService.instance.setOrder(s.id, prev.order);
                                await FirestoreService.instance.setOrder(prev.id, s.order);
                              },
                      ),
                      _actionIcon(
                        Icons.arrow_downward_rounded,
                        'تأخير',
                        next == null
                            ? null
                            : () async {
                                await FirestoreService.instance.setOrder(s.id, next.order);
                                await FirestoreService.instance.setOrder(next.id, s.order);
                              },
                      ),
                      _actionIcon(
                        Icons.edit_rounded,
                        'تعديل',
                        () => showDialog(
                          context: context,
                          builder: (_) => SessionFormDialog(existing: s),
                        ),
                      ),
                      _actionIcon(
                        Icons.delete_outline_rounded,
                        'حذف',
                        () async {
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
                        color: AppColors.rose,
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
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة برنامج'),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String tooltip, VoidCallback? onPressed, {Color? color}) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 17),
      color: color ?? AppColors.textMuted,
      onPressed: onPressed,
      splashRadius: 18,
      visualDensity: VisualDensity.compact,
    );
  }
}
