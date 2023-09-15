

import 'package:flutter/material.dart';

import 'home_widget.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Calls',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        primaryColor: Colors.tealAccent
      ),
      home: const HomeWidget() ,
    );
  }
}