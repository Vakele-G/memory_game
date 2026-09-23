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
        //titleTextStyle: TextStyle(fontFamily: "sans-seriff"),
        title: const Text("Letter Memory"),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, childe) {
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

class Tile extends StatelessWidget {
  const Tile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("A")],
        ),
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
