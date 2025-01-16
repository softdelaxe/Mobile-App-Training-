import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home.dart';
void main() {
  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeditationHomeScreen(),
    );
  }
}
