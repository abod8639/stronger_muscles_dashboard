---
name: Stronger Muscles Dashboard AI Skills
description: Guidelines and best practices for developing the Stronger Muscles Dashboard Flutter application.
---

# 🤖 AI Assistant Skills: Stronger Muscles Dashboard (Flutter)

هذا الملف يعمل كمرجع لك عند العمل على تطبيق **Stronger Muscles Dashboard** المبني بـ Flutter. التزم دائماً بالقواعد المعمارية ومبادئ التصميم التالية لضمان نظافة وجودة الكود.

## 🏗️ 1. المبادئ الهيكلية (Architecture & Principles)
*   **SOLID Principles:** اتبع المبادئ الخمسة (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion) بصرامة.
*   **Clean Architecture:** تأكد من فصل منطق الأعمال (Business Logic) عن طبقة الواجهة الرسومية (UI).
*   **التنظيم (Project Structure):** الالتزام بالتنظيم الحالي للمجلدات (`lib/data`, `lib/controllers`, `lib/screens`, إلخ).

## 🚀 2. إدارة الحالة والتوجيه (State Management & Routing)
*   استخدم **GetX** (`get` package) بشكل حصري لإدارة الحالة، حقن التبعيات (Dependency Injection)، والتوجيه (Routing).
*   تجنب استخدام `StatefulWidget` إلا للضرورة القصوى (مثل الأنيميشن المخصص) واعتمد على `GetxController` و `Obx` للتحديثات التفاعلية.

## 🔌 3. الاتصال بالخادم وواجهات برمجة التطبيقات (API Connection)
*   **Base URL:** تأكد من استخدام البروتوكول الصحيح والمنفذ (`http://192.168.1.17:8080/api/v1`). تجنب استخدام `localhost` في طلبات API لأن المحاكي / الأجهزة الحقيقية لها عناوين IP مختلفة عن الـ localhost الخاص بـ Laravel.
*   **الخدمات (Services):** يجب تمرير جميع الطلبات من خلال فئات الخدمات الموجودة في `lib/data/services/api/` (مثل `CategoryService`, `ProductService`) الموروثة من `ApiBase`.
*   لا تستخدم مكتبة HTTP الأساسية، التطبيق يعتمد على **Dio** مع Interceptors مهيأة في `ApiBase`.

## 💾 4. التخزين المؤقت وحفظ البيانات (Caching & Local Storage)
*   استخدم `GetStorage` لتخزين البيانات البسيطة مثل رموز المصادقة (Tokens) وبيانات المستخدم.
*   استخدم `Hive` لتخزين الكائنات المعقدة والاستجابات التي تحتاج إلى تخزين محلي لتقليل الاستدعاءات المتكررة للواجهات (مثل `CacheService`).

## 🎨 5. تصميم الواجهات (UI Guidelines)
*   تجنب تكرار الكود. استخدم الـ Widgets المخصصة (Custom Widgets) القابلة لإعادة الاستخدام في مجلد `components`.
*   قلل من عمليات إعادة بناء الواجهة (Rebuilds) غير الضرورية؛ استخدم `const` لجميع الـ Widgets الثابتة.
*   اعتمد على الألوان من `AppColors` والتنسيقات من `AppTheme` / `AppThemeExtended`.

## 🛡️ 6. المصادقة (Authentication)
*   لأي عملية تتطلب مصادقة (Admin/Customer)، تأكد من أن الـ `Token` يُرسل تلقائيًا عن طريق `Dio Interceptors` الموجودة سلفاً في التطبيق.

---
**تذكر دائمًا:** الدّقة والموثوقية هما الأساس. لا تقدم افتراضات بدلاً من قراءة الكود والمشروع.
