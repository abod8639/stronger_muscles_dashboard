import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// يحفظ الإعلان ويغلق الصفحة عند النجاح (يستخدمه زر الشريط العلوي وبطاقة الحفظ)
Future<void> savePromoAndClose(
  BuildContext context,
  PromoFormController controller,
) async {
  final success = await controller.savePromo();
  if (success && context.mounted) Navigator.of(context).pop();
}

/// زر حفظ ونشر الإعلان بعرض كامل
class PromoSaveActionCard extends StatelessWidget {
  final PromoFormController controller;

  const PromoSaveActionCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = controller.isEditing;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => FilledButton.icon(
        onPressed: controller.isLoading
            ? null
            : () => savePromoAndClose(context, controller),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        icon: controller.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Icon(
                isEditing ? Icons.save_rounded : Icons.check_circle_rounded,
                size: 20,
              ),
        label: Text(isEditing ? 'حفظ التعديلات' : 'نشر الإعلان في المتجر'),
      ),
    );
  }
}
