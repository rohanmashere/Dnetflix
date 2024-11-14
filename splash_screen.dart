import 'package:app/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/netflix-logo.webp'), // Add your image
      ),
    );
  }
}
