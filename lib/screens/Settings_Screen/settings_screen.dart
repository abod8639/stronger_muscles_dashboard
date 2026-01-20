import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/auth_controller.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernDropdown.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // تعريف القوائم كـ Static لتحسين الأداء
  static const List<DropdownMenuItem<String>> _apiItems = [
    DropdownMenuItem(value: 'http://localhost:8080/api/v1', child: Text('Localhost (Web)')),
    DropdownMenuItem(value: 'http://10.0.2.2:8080/api/v1', child: Text('Emulator (Android)')),
    DropdownMenuItem(value: 'http://192.168.1.17:8080/api/v1', child: Text('Local IP')),
  ];

  @override
  Widget build(BuildContext context) {
    // استدعاء الـ Controllers المتوفرة في الذاكرة
    final apiConfig = Get.put(ApiConfigController());
    final authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم إعدادات الـ API
              _buildSectionCard(
                title: 'إعدادات الاتصال',
                child: Obx(() => CustomModernDropdown(
                      value: apiConfig.baseUrl.value,
                      items: _apiItems,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          apiConfig.baseUrl.value = newValue;
                          // هنا يمكنك إضافة منطق لحفظ القيمة في GetStorage
                        }
                      },
                    )),
              ),

              const SizedBox(height: 24),

              // قسم الحساب
              _buildSectionCard(
                title: 'الحساب',
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(authController),
                    icon: const Icon(Icons.logout),
                    label: const Text('تسجيل الخروج'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت فرعية لتقليل تكرار الكود في التصميم
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}