import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitgram/screens/home_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/habits.png'),
            const Text(
              'Welcome to Habitgram',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => HomeScreen());
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
