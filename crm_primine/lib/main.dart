import 'package:flutter/material.dart';
import 'package:crm_primine/auth/login_page.dart';

import 'auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primine CRM',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
