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

## البيانات

لا توجد أي بيانات برنامج داخل الكود — كل شيء يُقرأ ويُحرَّر مباشرة من
Cloud Firestore (مشروع `bahah-ed88e`) عبر `FirestoreService`:

- **`config/settings`**: مستند `campStartDate` (تاريخ بداية المخيم).
- **`sessions/*`**: 51 فقرة برنامج (تفريغ يدوي من صور الجداول الأربعة
  الأصلية، الإثنين → الخميس) رُفعت مباشرة إلى القاعدة.

**تنبيه:** الأوقات والتفاصيل الدقيقة تم قراءتها من أرقام عربية بخط صغير
في الصور الأصلية، فمن المتوقع وجود بعض الأخطاء الطفيفة — راجع/صحّح أي
فقرة عبر زر "تعديل" في لوحة التحكم (`/control`).

تاريخ بداية المخيم مضبوط حالياً على **2026-08-17**، ويمكن تغييره في أي
وقت من لوحة التحكم (الشريط العلوي) — كل الأوقات والعدّادات التنازلية
تُحسب بناءً على هذا التاريخ.

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

### عبر Vercel (لا يحتاج تثبيت Flutter على جهازك إطلاقاً)

المشروع معه ملف `vercel.json` جاهز يجعل Vercel نفسه يثبّت Flutter
ويبني الموقع أثناء عملية النشر السحابية — أنت فقط تربط المستودع:

1. افتح [vercel.com](https://vercel.com) وسجّل الدخول (يمكن مباشرة
   بحساب GitHub).
2. **Add New... → Project → Import Git Repository** واختر
   `m7nmri-byte/nmas`.
3. عند شاشة الإعدادات: اترك **Framework Preset = Other** (سيُقرأ باقي
   الإعدادات — أمر البناء ومجلد الإخراج — تلقائياً من `vercel.json`).
4. اضغط **Deploy** وانتظر (أول بناء يأخذ دقائق قليلة إضافية لأنه يحمّل
   Flutter SDK نفسه).

بعد اكتمال النشر ستحصل على رابط مثل `https://nmas.vercel.app`:

- رابط العرض: `https://nmas.vercel.app/view`
- رابط التحكم: `https://nmas.vercel.app/control`

وميزة إضافية: أي تعديل تدفعه لاحقاً إلى فرع `main` على GitHub سيُعاد نشره
تلقائياً على نفس الرابط.

### عبر Firebase Hosting (بديل، يحتاج Flutter مثبتاً محلياً)

```bash
flutter build web
firebase deploy --only hosting
```

بعد النشر ستحصل على رابط مثل `https://your-project.web.app`، وعندها:

- رابط العرض: `https://your-project.web.app/view`
- رابط التحكم: `https://your-project.web.app/control`

(إعادة الكتابة (`rewrites`) في `firebase.json` مضبوطة مسبقاً بحيث يعمل
التوجيه الداخلي لـ Flutter بشكل صحيح مع أي مسار).

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
    firestore_service.dart      قراءة/كتابة Firestore (كل البيانات من هنا)
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
