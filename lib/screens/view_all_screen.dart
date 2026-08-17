import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/app_settings.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';
import '../widgets/session_card.dart';

/// شاشة عرض كل فقرات البرنامج مجمّعة حسب اليوم.
class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kDayNames.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كل البرنامج'),
          bottom: TabBar(
            tabs: [for (final d in kDayNames) Tab(text: d)],
          ),
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
                final now = DateTime.now();
                return TabBarView(
                  children: [
                    for (var day = 1; day <= kDayNames.length; day++)
                      _DayList(
                        sessions: sessions.where((s) => s.dayIndex == day).toList(),
                        campStart: campStart,
                        now: now,
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

class _DayList extends StatelessWidget {
  final List<Session> sessions;
  final DateTime campStart;
  final DateTime now;

  const _DayList({
    required this.sessions,
    required this.campStart,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(child: Text('لا توجد فقرات لهذا اليوم'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final s = sessions[index];
        final isCurrent = !now.isBefore(s.startDateTime(campStart)) &&
            now.isBefore(s.endDateTime(campStart));
        return SessionListTile(
          session: s,
          campStart: campStart,
          highlight: isCurrent,
        );
      },
    );
  }
}
