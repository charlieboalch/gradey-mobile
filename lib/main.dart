import 'package:flutter/material.dart';
import 'package:gradey/routes/class.dart';
import 'package:gradey/routes/home.dart';
import 'package:gradey/routes/login.dart';

void main() => runApp(MaterialApp(
  title: 'Gradey',
  initialRoute: '/login',
  routes: {
    '/login': (context) => const LoginRoute(),
    '/home': (context) => const HomeRoute(),
    '/class': (context) => const ClassRoute(),
  },
));