import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'package:trova/theme/app_theme.dart';
import 'auth/login_page.dart';
//import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<ApiService>(ApiService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Trova",
      theme: AppTheme.theme,
      home: const LoginPage(),
    );
  }
}
