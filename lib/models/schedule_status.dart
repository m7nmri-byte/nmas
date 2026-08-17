import 'session.dart';

/// يحسب البرنامج الحالي/السابق/القادم بناءً على الوقت الآن.
class ScheduleStatus {
  final Session? current;
  final Session? past;
  final Session? next;

  const ScheduleStatus({this.current, this.past, this.next});

  static ScheduleStatus compute(
    List<Session> sessions,
    DateTime campStart,
    DateTime now,
  ) {
    Session? current;
    Session? past;
    Session? next;

    for (final s in sessions) {
      final start = s.startDateTime(campStart);
      final end = s.endDateTime(campStart);

      if (!now.isBefore(start) && now.isBefore(end)) {
        current = s;
      } else if (!end.isAfter(now)) {
        if (past == null || end.isAfter(past.endDateTime(campStart))) {
          past = s;
        }
      } else if (start.isAfter(now)) {
        if (next == null || start.isBefore(next.startDateTime(campStart))) {
          next = s;
        }
      }
    }

    return ScheduleStatus(current: current, past: past, next: next);
  }
}
