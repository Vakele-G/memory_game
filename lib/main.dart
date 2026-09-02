import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            for (int j = 1; j <= 7; j++)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [for (int i = 1; i <= 7; i++) Tile()],
              ),
          ],
        ),)

      )
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        width: 50,
        height: 50,
        child: Card(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("A")],
          ),
        )
      );
  }
}
