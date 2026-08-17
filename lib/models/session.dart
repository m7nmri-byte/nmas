import 'package:cloud_firestore/cloud_firestore.dart';

/// فقرة/برنامج واحد ضمن جدول المخيم.
class Session {
  final String id;
  final int dayIndex; // 1..4
  final String dayName;
  final int order; // ترتيب الفقرة داخل اليوم
  final String title; // البرنامج
  final String venue; // المقر
  final String responsible; // المكلف
  final String startTime; // HH:mm بصيغة 24 ساعة
  final String endTime; // HH:mm بصيغة 24 ساعة
  final bool endsNextDay; // تنتهي بعد منتصف الليل (مثل فقرات النوم)
  final String notes;

  const Session({
    required this.id,
    required this.dayIndex,
    required this.dayName,
    required this.order,
    required this.title,
    required this.venue,
    required this.responsible,
    required this.startTime,
    required this.endTime,
    this.endsNextDay = false,
    this.notes = '',
  });

  factory Session.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const <String, dynamic>{};
    return Session(
      id: doc.id,
      dayIndex: (d['dayIndex'] as num?)?.toInt() ?? 1,
      dayName: d['dayName'] as String? ?? '',
      order: (d['order'] as num?)?.toInt() ?? 0,
      title: d['title'] as String? ?? '',
      venue: d['venue'] as String? ?? '',
      responsible: d['responsible'] as String? ?? '',
      startTime: d['startTime'] as String? ?? '00:00',
      endTime: d['endTime'] as String? ?? '00:00',
      endsNextDay: d['endsNextDay'] as bool? ?? false,
      notes: d['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'dayIndex': dayIndex,
        'dayName': dayName,
        'order': order,
        'title': title,
        'venue': venue,
        'responsible': responsible,
        'startTime': startTime,
        'endTime': endTime,
        'endsNextDay': endsNextDay,
        'notes': notes,
      };

  DateTime startDateTime(DateTime campStart) =>
      _combine(campStart, dayIndex, startTime, false);

  DateTime endDateTime(DateTime campStart) =>
      _combine(campStart, dayIndex, endTime, endsNextDay);

  Duration duration(DateTime campStart) =>
      endDateTime(campStart).difference(startDateTime(campStart));

  static DateTime _combine(
      DateTime campStart, int dayIndex, String hhmm, bool nextDay) {
    final base = DateTime(campStart.year, campStart.month, campStart.day)
        .add(Duration(days: dayIndex - 1 + (nextDay ? 1 : 0)));
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return DateTime(base.year, base.month, base.day, h, m);
  }

  Session copyWith({
    int? dayIndex,
    String? dayName,
    int? order,
    String? title,
    String? venue,
    String? responsible,
    String? startTime,
    String? endTime,
    bool? endsNextDay,
    String? notes,
  }) {
    return Session(
      id: id,
      dayIndex: dayIndex ?? this.dayIndex,
      dayName: dayName ?? this.dayName,
      order: order ?? this.order,
      title: title ?? this.title,
      venue: venue ?? this.venue,
      responsible: responsible ?? this.responsible,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      endsNextDay: endsNextDay ?? this.endsNextDay,
      notes: notes ?? this.notes,
    );
  }
}

String formatDuration(Duration d) {
  if (d.isNegative) return '0 دقيقة';
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h > 0 && m > 0) return '$h س $m د';
  if (h > 0) return '$h ساعة';
  return '$m دقيقة';
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

/// يعرض الوقت بنظام ١٢ ساعة مع لاحقة صباحاً/مساءً (ص / م).
String formatClock(DateTime t) {
  final period = t.hour < 12 ? 'ص' : 'م';
  var h12 = t.hour % 12;
  if (h12 == 0) h12 = 12;
  return '${twoDigits(h12)}:${twoDigits(t.minute)} $period';
}
