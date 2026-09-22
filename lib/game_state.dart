import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:async';

import 'tile_model.dart';

enum GamePhase { initial, memorizing, recalling, finished }

class GameState extends ChangeNotifier {
  List<TileModel> tiles = [];
  List<String> targetLetters = [];
  GamePhase phase = GamePhase.initial;
  String resultMessage = "";

  final int totalTiles = 64;
  final int targetCount = 7;
  final Random _random = Random();

  GameState() {
    startGame();
  }

  void startGame() {
    resultMessage = "";
    targetLetters.clear();

    // Generate 64 blank tiles
    tiles = List.generate(totalTiles, (int index) => TileModel(id: index));

    // Pick 7 random tile positions on the board
    Set<int> targetIndexes = {};
    while (targetIndexes.length < targetCount) {
      targetIndexes.add(_random.nextInt(totalTiles));
    }

    // Assign random letters to the 7 tiles and set them face up
    for (int i in targetIndexes) {
      String randomLetter = String.fromCharCode(_random.nextInt(26) + 65);
      tiles[i].letter = randomLetter;
      tiles[i].isFlipped = true;
      targetLetters.add(randomLetter);
    }

    phase = GamePhase.memorizing;
    notifyListeners();

    // Start the memorization timer
    Timer(const Duration(seconds: 4), () {
      for (var tile in tiles) {
        tile.isFlipped = false;
      }
      phase = GamePhase.recalling;
      notifyListeners();
    });
  }
}
