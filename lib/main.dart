import 'package:flutter/material.dart';
import 'package:mobile/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Souch K Khana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFFFFA726)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
