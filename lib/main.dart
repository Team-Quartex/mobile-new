import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:trova/theme/app_theme.dart';
=======
import 'package:travel/theme/app_theme.dart';
>>>>>>> 93870a743b9b957b848a57c75b0591490b961af4
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
<<<<<<< HEAD
      home:  HomePage(),
=======
      home:  LoginPage(),
>>>>>>> 93870a743b9b957b848a57c75b0591490b961af4
    );
  }

}
