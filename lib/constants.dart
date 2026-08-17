/// كلمة مرور الدخول إلى لوحة التحكم.
/// هذا حماية بسيطة على مستوى الواجهة فقط، راجع firestore.rules لملاحظة الأمان.
const String kControlPassword = '123123';

const String kPrefsControlAuthedKey = 'control_authed';

const List<String> kDayNames = [
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
];
