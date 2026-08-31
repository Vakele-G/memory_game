import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int j = 1; j <= 8; j++)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (int i = 1; i <= 8; i++) Icon(Icons.cloud)],
            ),
        ],
      ),
    );
  }
}
