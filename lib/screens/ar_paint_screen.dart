import 'package:flutter/material.dart';

class ARPaintScreen extends StatelessWidget {
  const ARPaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Paint')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to AR Paint!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add AR Paint functionality here
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
