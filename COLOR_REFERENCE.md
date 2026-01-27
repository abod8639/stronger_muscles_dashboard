# 🎨 دليل الألوان المرجعي

## 📋 نظام الألوان الكامل

### 🌑 الخلفيات والسطوح

```
████████ #0F0F1E - darkBg (خلفية التطبيق الرئيسية)
████████ #1A1A2E - surfaceDark (السطوح المظلمة)
████████ #16213E - cardBg (خلفية البطاقات)
████████ #1F2937 - cardBgLight (خلفية البطاقات الأفتح)
```

### 🔲 الحدود والفواصل

```
████████ #2D3748 - borderColor (حدود ناعمة)
████████ #3F4654 - borderColorLight (حدود أفتح)
```

### 📝 ألوان النصوص

```
████████ #E8EAED - textPrimary (النص الأساسي - أبيض)
████████ #B0B3B8 - textSecondary (النص الثانوي)
████████ #8A8D93 - textMuted (النص الخافت)
```

---

## 🎭 ألوان الحالات والمؤشرات

### 💜 البنفسجي (Ethereum)

```
████████ #B897EE - purpleAccent (اللون الفاتح)
████████ #7C3AED - purpleDark (اللون الداكن)
████████ #DDD6FE - purpleLight (نسخة فاتحة جداً)
```

**الاستخدام:**
- المؤشرات الرئيسية
- البيانات المهمة
- النقاط المميزة

### 🟠 البرتقالي (BNB Chain)

```
████████ #FBBF24 - orangeAccent (اللون الأساسي)
████████ #F59E0B - orangeDark (اللون الداكن)
████████ #FED7AA - orangeLight (نسخة فاتحة)
```

**الاستخدام:**
- الحالات المعلقة
- التنبيهات والتنويهات
- العناصر قيد الانتظار

### 💗 الوردي/الوردي الفاقع (Polygon)

```
████████ #F472B6 - pinkAccent (اللون الأساسي)
████████ #EC4899 - pinkDark (اللون الداكن)
████████ #FCE7F3 - pinkLight (نسخة فاتحة)
```

**الاستخدام:**
- الحالات النشطة
- العناصر المختارة
- الحالات الخاصة

### 💙 الأزرق السماوي (Cyan)

```
████████ #22D3EE - cyanAccent (اللون الأساسي)
████████ #06B6D4 - cyanDark (اللون الداكن)
```

**الاستخدام:**
- البيانات والتفاصيل
- الرسوم البيانية
- المعلومات الإضافية

### 💚 الأخضر (Success)

```
████████ #10B981 - greenAccent (اللون الأساسي)
████████ #D1FAE5 - greenLight (نسخة فاتحة)
```

**الاستخدام:**
- الحالات الناجحة
- الطلبات المكتملة
- الحالات الإيجابية

### ❤️ الأحمر (Error)

```
████████ #EF4444 - redAccent (اللون الأساسي)
████████ #FEE2E2 - redLight (نسخة فاتحة)
```

**الاستخدام:**
- الحالات الملغاة
- الأخطاء والمشاكل
- التحذيرات الخطيرة

---

## 🎯 أمثلة الاستخدام

### مثال 1: خلفية الشاشة الرئيسية
```dart
Scaffold(
  backgroundColor: AppColorsExtended.darkBg, // #0F0F1E
  body: Container(),
)
```

### مثال 2: نص أساسي
```dart
Text(
  'مرحبا',
  style: TextStyle(color: AppColorsExtended.textPrimary), // #E8EAED
)
```

### مثال 3: بطاقة بنفسجية
```dart
Container(
  decoration: BoxDecoration(
    color: AppColorsExtended.cardBg, // #16213E
    border: Border.all(
      color: AppColorsExtended.purpleAccent, // #B897EE
    ),
  ),
)
```

### مثال 4: حالة معلقة (برتقالي)
```dart
Container(
  color: AppColorsExtended.orangeAccent, // #FBBF24
  child: Text('معلقة'),
)
```

### مثال 5: حالة ناجحة (أخضر)
```dart
Container(
  color: AppColorsExtended.greenAccent, // #10B981
  child: Text('نجاح'),
)
```

---

## 📊 جدول المرجعية السريعة

| الاستخدام | اللون | الكود | الثابت |
|-----------|-------|------|-------|
| خلفية الشاشة | أسود عميق | #0F0F1E | darkBg |
| خلفية البطاقة | أزرق داكن | #16213E | cardBg |
| نص أساسي | أبيض | #E8EAED | textPrimary |
| نص ثانوي | رمادي فاتح | #B0B3B8 | textSecondary |
| المعلقات | برتقالي | #FBBF24 | orangeAccent |
| المعالجة | سماوي | #22D3EE | cyanAccent |
| الناجح | أخضر | #10B981 | greenAccent |
| الملغى | أحمر | #EF4444 | redAccent |
| رئيسي | بنفسجي | #B897EE | purpleAccent |

---

## 🌈 التدرجات المعرّفة

### تدرج بنفسجي
```dart
AppColorsExtended.purpleGradient
// من: purpleDark (#7C3AED) الشفاف
// إلى: purpleAccent (#B897EE) الشفاف
```

### تدرج برتقالي
```dart
AppColorsExtended.orangeGradient
// من: orangeDark (#F59E0B) الشفاف
// إلى: orangeAccent (#FBBF24) الشفاف
```

### تدرج وردي
```dart
AppColorsExtended.pinkGradient
// من: pinkDark (#EC4899) الشفاف
// إلى: pinkAccent (#F472B6) الشفاف
```

---

## ✨ الظلال المعرّفة

### ظل البطاقة (cardShadow)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 4),
)
```

### ظل ناعم (softShadow)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

---

## 🎨 نصائح الاستخدام

### 1. استخدم الألوان المتكاملة
```dart
// ✅ صحيح - ألوان متسقة
Container(
  color: AppColorsExtended.cardBg,
  border: Border.all(
    color: AppColorsExtended.purpleAccent,
  ),
)

// ❌ خطأ - ألوان عشوائية
Container(
  color: Colors.grey[800],
  border: Border.all(color: Colors.purple),
)
```

### 2. استخدم الشفافية بذكاء
```dart
// ✅ صحيح
accentColor.withValues(alpha: 0.2) // 20% شفافية

// ❌ خطأ
accentColor.withOpacity(0.2)
```

### 3. اجمع بين اللون والنص بشكل صحيح
```dart
// ✅ صحيح - نص واضح
Text(
  'مرحبا',
  style: TextStyle(
    color: AppColorsExtended.textPrimary, // أبيض
    backgroundColor: AppColorsExtended.darkBg, // أسود
  ),
)

// ❌ خطأ - قراءة صعبة
Text(
  'مرحبا',
  style: TextStyle(
    color: AppColorsExtended.textMuted, // رمادي
    backgroundColor: AppColorsExtended.surfaceDark, // أزرق داكن
  ),
)
```

---

## 📐 اختبار التباين

للتأكد من أن الألوان واضحة:

| الخلفية | النص | التباين | الحالة |
|---------|------|---------|--------|
| #0F0F1E | #E8EAED | عالي جداً | ✅ واضح جداً |
| #16213E | #E8EAED | عالي | ✅ واضح |
| #16213E | #B0B3B8 | متوسط | ⚠️ مقبول |
| #16213E | #8A8D93 | منخفض | ❌ خافت |

---

## 🚀 الخلاصة

استخدم `AppColorsExtended` دائماً للألوان المتسقة والاحترافية:

```dart
// القالب الموصى به
import 'package:stronger_muscles_dashboard/config/app_colors.dart';

// الاستخدام
color: AppColorsExtended.darkBg,
textColor: AppColorsExtended.textPrimary,
accentColor: AppColorsExtended.purpleAccent,
```

---

**هذا دليل كامل لنظام الألوان!** 🎨
