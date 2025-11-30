import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  final int minutes;
  final int seconds;

  const TimerScreen({super.key, required this.minutes, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Timer',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Minutes: $minutes',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Seconds: $seconds',
              style: const TextStyle(fontSize: 20),
            ),
            // Add a countdown timer or any other game logic here
          ],
        ),
      ),
    );
  }
}
