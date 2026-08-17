# برنامج المخيم — عرض وتحكم مباشر

تطبيق Flutter (ويب) متصل بـ Cloud Firestore، يوفّر رابطين:

- **رابط العرض** (`/view`): عام، للجميع. يعرض الوقت الحالي، البرنامج الحالي
  مع عدّاد تنازلي ومتى بدأ/ينتهي، البرنامج السابق، البرنامج القادم مع عدّاد
  حتى بدايته، وزر "عرض الكل" لعرض كامل جدول الأيام الأربعة.
- **رابط التحكم** (`/control`): محمي بكلمة مرور، ويعرض نفس معلومات الحالة
  المباشرة بالإضافة إلى إدارة كاملة للبرنامج: إضافة / تعديل / حذف / تقديم
  وتأخير الفقرات، وتعديل تاريخ بداية المخيم.

كلمة مرور التحكم الحالية: **123123** (معرّفة في `lib/constants.dart`،
يمكن تغييرها من هناك).

> ⚠️ **ملاحظة أمنية**: لا يوجد نظام مصادقة حقيقي (Firebase Auth) هنا —
> كلمة المرور هي بوابة بسيطة على مستوى الواجهة فقط، وقواعد Firestore
> (`firestore.rules`) مفتوحة للقراءة والكتابة لأي شخص يعرف رابط المشروع.
> هذا مناسب لأداة داخلية بسيطة، وليس آمناً بمعنى صارم. للحماية الحقيقية
> لاحقاً: فعّل Firebase App Check أو أضف Firebase Authentication وقيّد
> الكتابة بـ `request.auth != null` في القواعد.

## البيانات الابتدائية

ملف `lib/services/seed_data.dart` يحتوي على تفريغ يدوي لكل فقرات البرنامج
من صور الجداول الأربعة (الإثنين → الخميس) التي زوّدتني بها. **الأوقات
والتفاصيل الدقيقة تم قراءتها من أرقام عربية بخط صغير في الصور، فمن
المتوقع وجود بعض الأخطاء الطفيفة** — راجع/صحّح كل فقرة عبر زر "تعديل" في
لوحة التحكم بعد الاستيراد. عدد الفقرات المفرغة: نحو 70 فقرة عبر الأيام
الأربعة.

هذه البيانات تُرفع تلقائياً إلى Firestore بالضغط على زر **"استيراد
البيانات الابتدائية"** الذي يظهر في أعلى لوحة التحكم عندما تكون قاعدة
البيانات فارغة.

**الأهم:** بعد الاستيراد، اضبط **"تاريخ بداية المخيم"** من لوحة التحكم
(الشريط العلوي) على التاريخ الحقيقي لليوم الأول (الإثنين) — كل الأوقات
والعدّادات التنازلية تُحسب بناءً على هذا التاريخ، وإن تُرك افتراضياً
(تاريخ اليوم عند أول تشغيل) ستكون العدّادات خاطئة.

## التشغيل محلياً

يتطلب المشروع تثبيت [Flutter SDK](https://docs.flutter.dev/get-started/install)
(هذا الجهاز لا يحتوي حالياً على Flutter أو Firebase CLI، لذا لم يُشغَّل
أو يُختبر المشروع فعلياً — الكود جاهز لكن يحتاج بيئة Flutter لديك).

```bash
flutter pub get
flutter run -d chrome
```

## ربط المشروع بـ Firebase

`lib/firebase_options.dart` معبأ بالفعل بإعدادات مشروع Firebase الحقيقي
**bahah-ed88e**. المتبقي فقط:

1. من [console.firebase.google.com](https://console.firebase.google.com)
   افتح مشروع `bahah-ed88e`، وتأكد أن **Cloud Firestore** مفعّل
   (Build → Firestore Database → Create database إن لم يكن موجوداً).
2. سجّل الدخول بـ Firebase CLI وحدّد المشروع (مرة واحدة فقط):
   ```bash
   firebase login
   firebase use bahah-ed88e
   ```
3. ارفع قواعد الأمان المرفقة في `firestore.rules`:
   ```bash
   firebase deploy --only firestore:rules
   ```

## النشر (الحصول على رابطين فعليين يعملان)

الخيار الأسهل هو **Firebase Hosting** (متوافق مباشرة مع `firebase.json`
المُعدّ مسبقاً في هذا المشروع):

```bash
flutter build web
firebase deploy --only hosting
```

بعد النشر ستحصل على رابط مثل `https://your-project.web.app`، وعندها:

- رابط العرض: `https://your-project.web.app/view`
- رابط التحكم: `https://your-project.web.app/control`

(إعادة الكتابة (`rewrites`) في `firebase.json` مضبوطة مسبقاً بحيث يعمل
التوجيه الداخلي لـ Flutter بشكل صحيح مع أي مسار).

يمكنك أيضاً استضافة `build/web` على أي مزوّد استضافة ثابت آخر (Netlify،
Vercel، GitHub Pages...) طالما يوجّه كل المسارات إلى `index.html` (نفس
فكرة الـ SPA rewrite).

## هيكل المشروع

```
lib/
  main.dart                     نقطة الدخول + التوجيه (go_router)
  constants.dart                كلمة مرور التحكم وأسماء الأيام
  firebase_options.dart         إعدادات Firebase (يُستبدل بـ flutterfire configure)
  models/
    session.dart                نموذج فقرة البرنامج
    app_settings.dart           إعدادات عامة (تاريخ بداية المخيم)
    schedule_status.dart        حساب البرنامج الحالي/السابق/القادم
  services/
    firestore_service.dart      قراءة/كتابة Firestore
    seed_data.dart               البيانات الابتدائية المفرغة من الصور
  screens/
    view_screen.dart            شاشة العرض الرئيسية
    view_all_screen.dart        عرض كل البرنامج (تبويب لكل يوم)
    control_gate_screen.dart    بوابة كلمة المرور
    control_panel_screen.dart   لوحة التحكم الكاملة
    session_form_dialog.dart    نموذج إضافة/تعديل فقرة
  widgets/
    countdown_text.dart         عدّاد تنازلي حي
    live_clock_text.dart        ساعة حية
    session_card.dart           بطاقات وعناصر عرض الفقرات
```

## نموذج بيانات Firestore

- **`config/settings`**: مستند واحد يحتوي `campStartDate` (تاريخ اليوم
  الأول للمخيم).
- **`sessions/{id}`**: مستند لكل فقرة برنامج:
  `dayIndex` (1-4)، `dayName`، `order` (ترتيب داخل اليوم)، `title`،
  `venue`، `responsible`، `startTime`/`endTime` (بصيغة `HH:mm`)،
  `endsNextDay` (true لفقرات النوم التي تمتد بعد منتصف الليل)، `notes`.
