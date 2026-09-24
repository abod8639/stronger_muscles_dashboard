export '../pages/promo_form_screen.dart';

import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promo_form_screen.dart';

/// تم ترقية هذه النافذة المنبثقة إلى صفحة كاملة متخصصة [PromoFormScreen]
/// بما يتوافق مع معايير Material Design 3.
/// تم الإبقاء على هذا الكائن لضمان التوافق العكسي (Backward Compatibility).
class PromoFormSheet extends StatelessWidget {
  final PromoEntity? promo;

  const PromoFormSheet({super.key, this.promo});

  @override
  Widget build(BuildContext context) {
    return PromoFormScreen(promo: promo);
  }
}
