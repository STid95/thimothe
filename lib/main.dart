import 'package:flutter/material.dart';
import 'package:thimothe/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Department game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC5DECD)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Trouve le département !'),
    );
  }
}
