import 'package:flutter/material.dart';

import 'tile_model.dart';

class TileWidget extends StatelessWidget {
  final TileModel tile;

  const TileWidget({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },

      child: tile.isFlipped
          ? Card(
              key: const ValueKey("front"),
              color: Colors.red,
              child: Center(
                child: Text(
                  tile.letter ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : const Card(
              key: ValueKey("back"),
              color: Colors.blueAccent,
              child: SizedBox.expand(),
            ),
    );
  }
}
