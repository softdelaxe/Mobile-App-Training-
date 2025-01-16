import 'package:flutter/material.dart';
import 'package:black_jack/home.dart';

void main() {
  runApp(const BlackJack());
}

class BlackJack extends StatelessWidget {
  const BlackJack({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
