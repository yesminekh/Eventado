import 'package:flutter/material.dart';
import 'singin.out/welcome_page.dart';

const color = const Color(0xFF6666ff);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      title: 'Eventado',
      home: WelcomePage(),
    );
  }
}
