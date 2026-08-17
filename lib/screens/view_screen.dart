import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/app_settings.dart';
import '../models/schedule_status.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';
import '../widgets/live_clock_text.dart';
import '../widgets/session_card.dart';

/// شاشة العرض العامة (رابط العرض فقط، بدون تحكم).
class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامج المخيم'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/view/all'),
            icon: const Icon(Icons.list_alt),
            label: const Text('عرض الكل'),
          ),
        ],
      ),
      body: StreamBuilder<AppSettings>(
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

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('الوقت الآن',
                              style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          LiveClockText(
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SessionStatusCard(
                    kind: SessionCardKind.current,
                    session: status.current,
                    campStart: campStart,
                  ),
                  const SizedBox(height: 12),
                  SessionStatusCard(
                    kind: SessionCardKind.next,
                    session: status.next,
                    campStart: campStart,
                  ),
                  const SizedBox(height: 12),
                  SessionStatusCard(
                    kind: SessionCardKind.past,
                    session: status.past,
                    campStart: campStart,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/view/all'),
                    icon: const Icon(Icons.list_alt),
                    label: const Text('عرض كل البرنامج'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
