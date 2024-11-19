import 'package:flutter/material.dart';
import 'package:travel/theme/app_theme.dart';
import 'Screens/home/HomePage.dart';
import 'auth/login_page.dart';
//import 'auth/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Trova",
      theme: AppTheme.theme,
      home:  LoginPage(),
    );
  }

}
