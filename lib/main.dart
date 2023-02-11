import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';

import 'package:worldxy04/components/playerComponent.dart';
import 'package:worldxy04/maps/tile_map_component.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Future<void>? onLoad() {
    var background = TileMapComponent();
    add(background);

    background.loaded.then(
      (value) {
        var player =
            PlayerComponent(game: this, mapSize: background.tiledMap.size, posPlayer: background.posPlayer);
        camera.followComponent(player,
            worldBounds: Rect.fromLTRB(
                0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
        add(player);
      },
    );

    add(ScreenHitbox());
  }

  @override
  backgroundColor() {
    super.backgroundColor();
    return Colors.purple;
  }
}

void main() {
  runApp(GameWidget(game: MyGame()));
}
