import 'package:get/get.dart';

/// تم الإبقاء على [AuthBinding] لضمان التوافق العكسي مع مسارات GetX
/// حيث تتم إدارة حالة المصادقة الآن عبر Riverpod [authControllerProvider].
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // تم نقل إدارة دورة الحياة والاعتماديات إلى Riverpod Providers
  }
}
