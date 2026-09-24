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

  final int totalTiles = 42;
  final int targetCount = 7;
  final Random _random = Random();

  GameState() {
    tiles = List.generate(totalTiles, (index) => TileModel(id: index));
    phase = GamePhase.initial;
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

  void submitAnswer(String input) {
    if (phase != GamePhase.recalling) return;

    // Sort the input and tile letters
    List<String> inputChars = input.trim().toUpperCase().split("")..sort();
    List<String> targetChars = List.from(targetLetters)..sort();

    if (inputChars.join() == targetChars.join()) {
      resultMessage = "Perfect! You remembered all of them,";
    } else {
      resultMessage = "Not quite! The letters were: ${targetChars.join(', ')}";
    }

    phase = GamePhase.finished;

    // Reveal the tiles again
    for (var tile in tiles) {
      if (tile.letter != null) tile.isFlipped = true;
    }
    notifyListeners();
  }
}
