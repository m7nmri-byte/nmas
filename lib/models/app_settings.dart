import 'package:cloud_firestore/cloud_firestore.dart';

/// إعدادات عامة للمخيم، محفوظة في مستند config/settings.
class AppSettings {
  final DateTime campStartDate; // تاريخ (بدون وقت) بداية اليوم الأول من المخيم

  const AppSettings({required this.campStartDate});

  factory AppSettings.fromMap(Map<String, dynamic>? d) {
    if (d == null || d['campStartDate'] == null) {
      final now = DateTime.now();
      return AppSettings(campStartDate: DateTime(now.year, now.month, now.day));
    }
    final ts = d['campStartDate'];
    final date = ts is Timestamp ? ts.toDate() : DateTime.now();
    return AppSettings(
      campStartDate: DateTime(date.year, date.month, date.day),
    );
  }

  Map<String, dynamic> toMap() => {
        'campStartDate': Timestamp.fromDate(campStartDate),
      };
}
