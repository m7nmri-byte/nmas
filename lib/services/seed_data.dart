import '../models/session.dart';

/// تاريخ افتراضي لبداية المخيم (يوم الإثنين) — عدّله فوراً من لوحة التحكم
/// (قسم الإعدادات) ليطابق التاريخ الحقيقي، وإلا سيكون العد التنازلي خاطئاً.
final DateTime kDefaultCampStartDate = () {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}();

/// بيانات مفرغة يدوياً من صور جدول البرنامج الأربع (الإثنين→الخميس).
///
/// ⚠️ تنبيه: تم تفريغ الأوقات والتفاصيل من صور بخط صغير بالأرقام العربية،
/// فمن المتوقع وجود بعض الأخطاء الطفيفة في الدقائق أو تفاصيل بعض الفقرات.
/// راجع/صحّح كل فقرة من لوحة التحكم (تعديل) بعد الاستيراد.
///
/// id يُترك فارغاً لأن Firestore يولّد المعرف تلقائياً عند الإضافة.
final List<Session> kSeedSessions = [
  // ============== اليوم الأول: الإثنين ==============
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 10,
    title: 'التجمع', venue: 'آخر المسجد', responsible: 'علي الحتو',
    startTime: '04:10', endTime: '04:35',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 20,
    title: 'صلاة الفجر', venue: 'المسجد', responsible: 'الجميع',
    startTime: '04:45', endTime: '05:15',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 30,
    title: 'الانطلاق', venue: '-', responsible: 'علي الحتو',
    startTime: '05:30', endTime: '09:00',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 40,
    title: 'الوصول', venue: '-', responsible: 'علي الحتو',
    startTime: '09:00', endTime: '09:30',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 50,
    title: 'تنزيل العفش + وقت مفتوح',
    venue: 'الاستراحة مقابل باب الدخول', responsible: 'اللجنة الاجتماعية',
    startTime: '09:30', endTime: '10:15',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 60,
    title: 'الجلسة الافتتاحية مع الشرح', venue: 'المشب', responsible: 'علي الحتو',
    startTime: '10:15', endTime: '11:00',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 70,
    title: 'إدخال العفش للغرف + لقاء أسري',
    venue: 'مقرات الأسر', responsible: 'قادة ومعلمي الأسر',
    startTime: '11:00', endTime: '11:45',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 80,
    title: 'صلاة المغرب والعشاء — كلمة طالب ١',
    venue: 'المشب', responsible: 'أسرة التعاون',
    startTime: '19:00', endTime: '19:30',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 90,
    title: 'درس المسؤولية — موانع / مسؤوليات في حياتنا',
    venue: 'المشب', responsible: 'أبو عبدالله — علي الحتو',
    startTime: '19:30', endTime: '20:45',
    notes: 'ساعة وربع تقريباً',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 100,
    title: 'كرة طائرة', venue: 'ملعب الطائرة', responsible: 'أبو فيصل',
    startTime: '21:00', endTime: '22:00',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 110,
    title: 'عشاء', venue: 'مقرات الأسر', responsible: 'اللجنة الاجتماعية',
    startTime: '22:10', endTime: '22:40',
  ),
  const Session(
    id: '', dayIndex: 1, dayName: 'الإثنين', order: 120,
    title: 'نوم', venue: 'مقرات الأسر', responsible: 'علي الحتو',
    startTime: '23:00', endTime: '04:00', endsNextDay: true,
  ),

  // ============== اليوم الثاني: الثلاثاء ==============
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 10,
    title: 'الاستيقاظ وصلاة الوتر', venue: 'مقرات الأسر', responsible: 'علي الحتو',
    startTime: '04:00', endTime: '04:30',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 20,
    title: 'صلاة الفجر — كلمة معلم ١', venue: 'المشب', responsible: 'أسرة الشموخ',
    startTime: '04:30', endTime: '05:00',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 30,
    title: 'جلسة إشراق + أذكار',
    venue: 'المشب', responsible: 'معلمي الأسر — متابعة علي الحتو',
    startTime: '05:00', endTime: '05:45',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 40,
    title: 'مهرجان حركي',
    venue: 'الساحة الخارجية', responsible: 'أ. أسامة إسحاق — أ. حسين',
    startTime: '06:00', endTime: '07:45',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 50,
    title: 'لقاء أسري', venue: 'مقرات الأسر', responsible: 'قادة ومعلمي الأسر',
    startTime: '08:00', endTime: '08:45',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 60,
    title: 'فطور', venue: 'مقرات الأسر', responsible: 'اللجنة الاجتماعية',
    startTime: '09:00', endTime: '09:30',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 70,
    title: 'نوم', venue: 'مقرات الأسر', responsible: 'علي الحتو',
    startTime: '09:30', endTime: '10:30',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 80,
    title: 'الاستيقاظ والتجهيز للانطلاق', venue: '-', responsible: 'علي الحتو',
    startTime: '10:30', endTime: '11:00',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 90,
    title: 'طلعة تنومة',
    venue: 'تنومة',
    responsible: 'أ. أسامة إسحاق، أ. حسين، عبدالجبار، أبو فيصل، اللجنة الاجتماعية',
    startTime: '11:00', endTime: '19:00',
    notes: 'تشمل: درس العفة (٣٠ دقيقة)، وقت ثقافي (ساعة)، وقت مفتوح (ساعة)، '
        'غداء، صلاة الظهر والعصر — كلمة طالب ٢',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 100,
    title: 'صلاة المغرب والعشاء + الوتر — كلمة طالب ٣',
    venue: 'الساحة الخارجية', responsible: 'أسرة الشموخ',
    startTime: '20:30', endTime: '21:15',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 110,
    title: 'جلسة أخوية وقفص الاتهام',
    venue: 'الساحة الخارجية', responsible: 'أبو فيصل',
    startTime: '21:15', endTime: '22:30',
    notes: 'ساعة وربع تقريباً',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 120,
    title: 'عشاء', venue: 'الساحة الخارجية', responsible: 'اللجنة الاجتماعية',
    startTime: '22:30', endTime: '23:15',
  ),
  const Session(
    id: '', dayIndex: 2, dayName: 'الثلاثاء', order: 130,
    title: 'نوم', venue: 'مقرات الأسر', responsible: 'علي الحتو',
    startTime: '23:30', endTime: '04:30', endsNextDay: true,
  ),

  // ============== اليوم الثالث: الأربعاء ==============
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 10,
    title: 'الاستيقاظ', venue: '-', responsible: 'علي الحتو',
    startTime: '04:00', endTime: '04:30',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 20,
    title: 'صلاة الفجر — كلمة معلم ٢',
    venue: 'الساحة الخارجية', responsible: 'أسرة الطموح',
    startTime: '04:30', endTime: '05:00',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 30,
    title: 'جلسة إشراق + أذكار',
    venue: 'الساحة الخارجية', responsible: 'معلمي الأسر — متابعة علي الحتو',
    startTime: '05:30', endTime: '06:15',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 40,
    title: 'طائرة', venue: 'ملعب الطائرة', responsible: 'أبو فيصل',
    startTime: '06:30', endTime: '07:30',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 50,
    title: 'وقت مفتوح وحبشتكات',
    venue: '-', responsible: 'قادة ومعلمي الأسر واللجنة الاجتماعية',
    startTime: '07:30', endTime: '08:00',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 60,
    title: 'لقاء أسري', venue: 'مقرات الأسر', responsible: 'قادة ومعلمي الأسر',
    startTime: '08:00', endTime: '08:45',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 70,
    title: 'ثقافي حركي',
    venue: 'مجلس السراميك', responsible: 'علي الحتو — مساعدة أ. حسين',
    startTime: '09:00', endTime: '10:15',
    notes: 'ساعة وربع تقريباً',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 80,
    title: 'نوم', venue: 'مقرات الأسر', responsible: 'علي الحتو',
    startTime: '10:15', endTime: '12:15',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 90,
    title: 'استيقاظ وركوب الباص', venue: '-', responsible: 'علي الحتو',
    startTime: '12:15', endTime: '12:30',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 100,
    title: 'طلعة المطل والفطور', venue: '-', responsible: 'أبو فيصل',
    startTime: '12:30', endTime: '16:30',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 110,
    title: 'العودة صلاة الظهر والعصر تأخير — كلمة طالب ٤',
    venue: 'المشب', responsible: 'أسرة الطموح',
    startTime: '16:30', endTime: '17:15',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 120,
    title: 'درس حسن الخلق: المعنى والأهمية وارتباطه بالمروءة',
    venue: 'المشب', responsible: 'أبو فيصل',
    startTime: '17:15', endTime: '18:30',
    notes: 'ساعة وربع تقريباً',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 130,
    title: 'صلاة المغرب والعشاء — كلمة طالب ٥',
    venue: 'المشب', responsible: 'أسرة الطموح',
    startTime: '19:15', endTime: '19:45',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 140,
    title: 'لقاء أسري أخير', venue: 'مقرات الأسر', responsible: 'قادة ومعلمي الأسر',
    startTime: '20:00', endTime: '21:30',
    notes: 'ساعة ونصف تقريباً',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 150,
    title: 'حفل السمر',
    venue: '؟؟', responsible: 'جميع المعلمين المتواجدين — علي الحتو',
    startTime: '22:00', endTime: '00:00', endsNextDay: true,
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 160,
    title: 'عشاء', venue: 'المشب', responsible: 'اللجنة الاجتماعية',
    startTime: '00:00', endTime: '01:00', endsNextDay: true,
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 170,
    title: 'وقت مفتوح وشاهي', venue: 'الساحة الخارجية', responsible: 'اللجنة الاجتماعية',
    startTime: '01:00', endTime: '01:30', endsNextDay: true,
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 180,
    title: 'التكريم', venue: 'المجلس الداخلي', responsible: 'حسين عبدالجبار',
    startTime: '01:30', endTime: '03:00', endsNextDay: true,
    notes: 'ساعة ونصف تقريباً',
  ),
  const Session(
    id: '', dayIndex: 3, dayName: 'الأربعاء', order: 190,
    title: 'جلسة المصارحة والمطارحة',
    venue: 'المجلس الداخلي', responsible: 'أبو فيصل — أ. حسين',
    startTime: '03:00', endTime: '04:30', endsNextDay: true,
    notes: 'ساعة ونصف تقريباً',
  ),

  // ============== اليوم الرابع والأخير: الخميس ==============
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 10,
    title: 'الأذان وصلاة الفجر', venue: 'المشب', responsible: 'علي الحتو',
    startTime: '05:00', endTime: '05:25',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 20,
    title: 'نوم', venue: 'مقرات الأسر', responsible: 'أبو فيصل',
    startTime: '05:30', endTime: '11:00',
    notes: 'خمس ساعات ونصف تقريباً',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 30,
    title: 'الاستيقاظ', venue: '-', responsible: 'أبو فيصل',
    startTime: '11:00', endTime: '11:30',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 40,
    title: 'تجهيز العفش',
    venue: 'الاستراحة مقابل باب الخروج', responsible: 'اللجنة الاجتماعية',
    startTime: '11:30', endTime: '12:30',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 50,
    title: 'الأذان وصلاة الظهر والعصر', venue: 'المشب', responsible: 'علي الحتو',
    startTime: '13:10', endTime: '13:30',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 60,
    title: 'كلمة ختامية', venue: 'المشب', responsible: 'علي الحتو — أبو فيصل',
    startTime: '13:30', endTime: '14:00',
  ),
  const Session(
    id: '', dayIndex: 4, dayName: 'الخميس', order: 70,
    title: 'الانطلاق والوصول', venue: '-', responsible: '-',
    startTime: '14:00', endTime: '23:30',
    notes: 'نهاية المخيم — تسع ساعات ونصف تقريباً (تشمل الرحلة والوصول للمنازل)',
  ),
];
