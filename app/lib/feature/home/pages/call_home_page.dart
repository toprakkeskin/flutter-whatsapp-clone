import 'package:flutter/material.dart';

class CallHomePage extends StatelessWidget {
  const CallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Chat Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.call),
      ),
    );
  }
}
