import 'package:chatgenie/colors.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatGenie',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColor.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.whiteColor,
        )
      ),
      home: const HomePage(),
    );
  }
}

