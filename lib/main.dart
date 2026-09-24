import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_state.dart';
import 'tile_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Letter Memory", home: const GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Memory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit Game',
            onPressed: () {
              // Tell the OS to safely close the app
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header/Status
                Text(
                  _getStatusText(gameState.phase),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Grid
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      // Constrain width so it doesn't stretch too wide on tablets
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageFiltered(imageFilter: ImageFilter.blur(
                            // If phase is initial, blur by 5 pixels. Else, 0 blur
                            sigmaX: gameState.phase == GamePhase.initial ? 5.0 : 0,
                            sigmaY: gameState.phase == GamePhase.initial ? 5.0 : 0,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: gameState.tiles.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                            ),
                            itemBuilder: (context, index) {
                              return TileWidget(tile: gameState.tiles[index]);
                            },
                          ),
                          ),

                          // Play button (top layer)
                          if (gameState.phase == GamePhase.initial)
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  gameState.startGame();
                                },
                                child: const Text(
                                  "PLAY",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),

                // Input and controls
                if (gameState.phase == GamePhase.recalling)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLength: gameState.targetCount,
                          decoration: const InputDecoration(
                            hintText: "Type the letters here..",
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            gameState.submitAnswer(value);
                            _inputController.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          gameState.submitAnswer(_inputController.text);
                          _inputController.clear();
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),

                if (gameState.phase == GamePhase.finished)
                  Column(
                    children: [
                      Text(
                        gameState.resultMessage,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => gameState.startGame(),
                        child: const Text("Play Again"),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _getStatusText(GamePhase phase) {
  switch (phase) {
    case GamePhase.memorizing:
      return "Memorize the letters!";
    case GamePhase.recalling:
      return "Type what you remember.";
    case GamePhase.finished:
      return "Game Over!";
    default:
      return "Get Ready...";
  }
}
