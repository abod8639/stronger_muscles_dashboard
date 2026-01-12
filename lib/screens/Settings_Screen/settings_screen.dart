import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernDropdown.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {


  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: 'http://localhost:8080/api/v1', child: Text('http://localhost:8080/api/v1')),
    DropdownMenuItem(value: 'http://10.0.2.2:8080/api/v1', child: Text('http://10.0.2.2:8080/api/v1')),
    DropdownMenuItem(value: 'http://192.168.1.17:8080/api/v1', child: Text('http://192.168.1.17:8080/api/v1')),
    ];

  // String value = 'http://localhost:8080/api/v1';

  void onChanged(String? newValue) {
    setState(() {
      ApiConfigController().baseUrl.value = newValue!;
    });
  }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body:  Center(
        child: Column(
          children: [
            CustomModernDropdown(
              value: ApiConfigController().baseUrl.value, 
              items: items, 
              onChanged: onChanged
              ),
          ],
        )
      ),
    );
  }
}