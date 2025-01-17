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
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Trouve le département !'),
    );
  }
}
