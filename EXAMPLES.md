# 🎨 أمثلة عملية على استخدام المكونات الجديدة

## مثال 1: إنشاء لوحة تحكم بسيطة

```dart
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/components/modern_indicator_card.dart';

class SimpleDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // بطاقة المؤشرات
              ModernIndicatorCard(
                title: 'المبيعات',
                value: '\$5,234',
                icon: Icons.trending_up,
                accentColor: AppColorsExtended.greenAccent,
                showTrend: true,
                trendUp: true,
                trendValue: '23.5%',
              ),
              SizedBox(height: 16),
              ModernIndicatorCard(
                title: 'الخسائر',
                value: '\$1,234',
                icon: Icons.trending_down,
                accentColor: AppColorsExtended.redAccent,
                showTrend: true,
                trendUp: false,
                trendValue: '5.2%',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## مثال 2: إنشاء بطاقة تفاصيل

```dart
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/components/detailed_staking_card.dart';

class DetailsSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg,
      appBar: AppBar(
        title: Text('التفاصيل'),
        backgroundColor: AppColorsExtended.cardBg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DetailedStakingCard(
          title: 'إحصائيات اليوم',
          subtitle: 'تم التحديث الآن',
          mainValue: '1,234',
          mainLabel: 'إجمالي العمليات',
          icon: Icons.analytics_outlined,
          accentColor: AppColorsExtended.purpleAccent,
          details: [
            StakingDetail(
              label: 'ناجحة',
              value: '98%',
              color: AppColorsExtended.greenAccent,
            ),
            StakingDetail(
              label: 'فاشلة',
              value: '2%',
              color: AppColorsExtended.redAccent,
            ),
            StakingDetail(
              label: 'قيد الانتظار',
              value: '12',
              color: AppColorsExtended.orangeAccent,
            ),
            StakingDetail(
              label: 'المتبقي',
              value: '5.2 س',
              color: AppColorsExtended.cyanAccent,
            ),
          ],
        ),
      ),
    );
  }
}
```

## مثال 3: شبكة من المؤشرات

```dart
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/components/modern_indicator_card.dart';

class IndicatorsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    
    final indicators = [
      {
        'title': 'المستخدمين',
        'value': '1,234',
        'color': AppColorsExtended.purpleAccent,
        'icon': Icons.people,
        'trend': true,
      },
      {
        'title': 'المشاريع',
        'value': '48',
        'color': AppColorsExtended.cyanAccent,
        'icon': Icons.folder,
        'trend': false,
      },
      {
        'title': 'المهام',
        'value': '342',
        'color': AppColorsExtended.orangeAccent,
        'icon': Icons.task_alt,
        'trend': true,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: res.isMobile ? 1 : (res.isTablet ? 2 : 3),
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: indicators.length,
      itemBuilder: (context, index) {
        final indicator = indicators[index];
        return ModernIndicatorCard(
          title: indicator['title'] as String,
          value: indicator['value'] as String,
          icon: indicator['icon'] as IconData,
          accentColor: indicator['color'] as Color,
          showTrend: true,
          trendUp: indicator['trend'] as bool,
          trendValue: '${(index + 1) * 5}%',
        );
      },
    );
  }
}
```

## مثال 4: رسم بياني مع البيانات

```dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_line_chart.dart';

class ChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // توليد بيانات تجريبية
    final spots = List.generate(
      30,
      (i) => FlSpot(
        i.toDouble(),
        (50 + (i * 2) + (i % 3) * 10).toDouble(),
      ),
    );

    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: EnhancedLineChartWidget(
          title: 'أداء المبيعات - آخر 30 يوم',
          spots: spots,
          lineColor: AppColorsExtended.cyanAccent,
          gradientColor: AppColorsExtended.cyanAccent,
          maxY: 200,
        ),
      ),
    );
  }
}
```

## مثال 5: صفحة كاملة

```dart
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/components/modern_indicator_card.dart';
import 'package:stronger_muscles_dashboard/components/detailed_staking_card.dart';

class CompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final res = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg,
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        backgroundColor: AppColorsExtended.cardBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(res.defaultPadding.left),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Text(
                'مرحباً بك',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: res.itemSpacing * 2),

              // المؤشرات الأساسية
              Text(
                'المؤشرات الرئيسية',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: res.itemSpacing),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: res.isMobile ? 1 : (res.isTablet ? 2 : 3),
                  childAspectRatio: 1.2,
                  crossAxisSpacing: res.itemSpacing,
                  mainAxisSpacing: res.itemSpacing,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final colors = [
                    AppColorsExtended.purpleAccent,
                    AppColorsExtended.cyanAccent,
                    AppColorsExtended.orangeAccent,
                  ];
                  return ModernIndicatorCard(
                    title: 'المؤشر ${index + 1}',
                    value: '${(index + 1) * 100}',
                    icon: Icons.trending_up,
                    accentColor: colors[index],
                    showTrend: true,
                    trendUp: true,
                    trendValue: '${(index + 1) * 10}%',
                  );
                },
              ),
              SizedBox(height: res.itemSpacing * 2),

              // البطاقة التفصيلية
              Text(
                'الملخص',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: res.itemSpacing),
              DetailedStakingCard(
                title: 'ملخص الأداء',
                mainValue: '2,456',
                mainLabel: 'إجمالي النقاط',
                icon: Icons.star,
                accentColor: AppColorsExtended.purpleAccent,
                details: [
                  StakingDetail(
                    label: 'المتبقي',
                    value: '1,234',
                    color: AppColorsExtended.greenAccent,
                  ),
                  StakingDetail(
                    label: 'المستخدم',
                    value: '1,222',
                    color: AppColorsExtended.redAccent,
                  ),
                  StakingDetail(
                    label: 'معدل الاستخدام',
                    value: '49.8%',
                    color: AppColorsExtended.cyanAccent,
                  ),
                  StakingDetail(
                    label: 'الحد الأقصى',
                    value: '5,000',
                    color: AppColorsExtended.orangeAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 💡 نصائح مهمة

1. **استخدم دائماً `AppColorsExtended`** - هكذا تضمن التناسق
2. **استخدم `context.responsive`** - للتخطيط الاستجابي
3. **أضف `SizedBox`** - بين العناصر للمسافات
4. **استخدم `GridView`** - للتخطيطات الشبكية

---

**استمتع بالتصميم الجديد!** 🎉
