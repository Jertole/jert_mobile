import 'package:flutter/material.dart';
import '../core/state/app_controller.dart';
import '../features/auth/splash_screen.dart';

class JertApp extends StatefulWidget {
  const JertApp({super.key});

  @override
  State<JertApp> createState() => _JertAppState();
}

class _JertAppState extends State<JertApp> {
  late final AppController controller;

  @override
  void initState() {
    super.initState();
    controller = AppController.mock();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JERT',
      theme: ThemeData.dark(),
      home: SplashScreen(controller: controller),
    );
  }
}
