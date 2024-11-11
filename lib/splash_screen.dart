//view class
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.themeColor,
  });

  final HSLColor themeColor;

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,//widget.themeColor.toColor(),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
