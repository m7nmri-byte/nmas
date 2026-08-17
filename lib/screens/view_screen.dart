import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/app_settings.dart';
import '../models/schedule_status.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';
import '../theme.dart';
import '../widgets/live_clock_text.dart';
import '../widgets/session_card.dart';

/// شاشة العرض العامة (رابط العرض فقط، بدون تحكم).
class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<AppSettings>(
          stream: FirestoreService.instance.watchSettings(),
          builder: (context, settingsSnap) {
            if (!settingsSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final campStart = settingsSnap.data!.campStartDate;
            return StreamBuilder<List<Session>>(
              stream: FirestoreService.instance.watchSessions(),
              builder: (context, sessionsSnap) {
                if (!sessionsSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final sessions = sessionsSnap.data!;
                if (sessions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'لا يوجد برنامج مضاف بعد.\nيمكن إضافته من رابط التحكم.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final status =
                    ScheduleStatus.compute(sessions, campStart, DateTime.now());
                final dayIndex = status.current?.dayIndex ??
                    status.next?.dayIndex ??
                    status.past?.dayIndex ??
                    1;

                return LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 860;
                  final content = wide
                      ? _WideLayout(status: status, campStart: campStart)
                      : _NarrowLayout(status: status, campStart: campStart);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TopBar(dayIndex: dayIndex),
                          const SizedBox(height: 20),
                          content,
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int dayIndex;
  const _TopBar({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.outline),
          ),
          child: Text('اليوم $dayIndex من ٤',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.textPrimary)),
        ),
        const Spacer(),
        LiveClockText(style: AppTheme.mono(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          onPressed: () => context.push('/view/all'),
          icon: const Icon(Icons.calendar_view_day_rounded, size: 20),
          tooltip: 'عرض الكل',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceRaised,
            foregroundColor: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  final ScheduleStatus status;
  final DateTime campStart;
  const _WideLayout({required this.status, required this.campStart});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SessionStatusCard(
            kind: SessionCardKind.current,
            session: status.current,
            campStart: campStart,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SessionStatusCard(
                kind: SessionCardKind.past,
                session: status.past,
                campStart: campStart,
              ),
              const SizedBox(height: 16),
              SessionStatusCard(
                kind: SessionCardKind.next,
                session: status.next,
                campStart: campStart,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final ScheduleStatus status;
  final DateTime campStart;
  const _NarrowLayout({required this.status, required this.campStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SessionStatusCard(
          kind: SessionCardKind.past,
          session: status.past,
          campStart: campStart,
        ),
        const SizedBox(height: 14),
        SessionStatusCard(
          kind: SessionCardKind.current,
          session: status.current,
          campStart: campStart,
        ),
        const SizedBox(height: 14),
        SessionStatusCard(
          kind: SessionCardKind.next,
          session: status.next,
          campStart: campStart,
        ),
      ],
    );
  }
}
