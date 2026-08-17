import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_settings.dart';
import '../models/session.dart';
import 'seed_data.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sessions =>
      _db.collection('sessions');

  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _db.collection('config').doc('settings');

  Stream<List<Session>> watchSessions() {
    return _sessions.snapshots().map((snap) {
      final list = snap.docs.map(Session.fromDoc).toList();
      list.sort((a, b) {
        final byDay = a.dayIndex.compareTo(b.dayIndex);
        if (byDay != 0) return byDay;
        return a.order.compareTo(b.order);
      });
      return list;
    });
  }

  Stream<AppSettings> watchSettings() {
    return _settingsDoc.snapshots().map((doc) => AppSettings.fromMap(doc.data()));
  }

  Future<void> setCampStartDate(DateTime date) {
    return _settingsDoc.set({
      'campStartDate':
          Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
    }, SetOptions(merge: true));
  }

  Future<void> addSession(Session s) => _sessions.add(s.toMap());

  Future<void> updateSession(Session s) => _sessions.doc(s.id).set(s.toMap());

  Future<void> deleteSession(String id) => _sessions.doc(id).delete();

  Future<void> setOrder(String id, int order) =>
      _sessions.doc(id).update({'order': order});

  /// يرفع بيانات البرنامج المفرغة من الجداول الأصلية إذا كانت القاعدة فارغة.
  Future<void> seedIfEmpty() async {
    final snap = await _sessions.limit(1).get();
    if (snap.docs.isNotEmpty) return;
    await seedNow();
  }

  /// يرفع بيانات البرنامج المبدئية بغض النظر عن المحتوى الحالي (يُستخدم من
  /// لوحة التحكم عند الحاجة لإعادة التعبئة).
  Future<void> seedNow() async {
    final batch = _db.batch();
    for (final s in kSeedSessions) {
      final ref = _sessions.doc();
      batch.set(ref, s.toMap());
    }
    batch.set(
      _settingsDoc,
      {'campStartDate': Timestamp.fromDate(kDefaultCampStartDate)},
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  Future<void> deleteAllSessions() async {
    final snap = await _sessions.get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
