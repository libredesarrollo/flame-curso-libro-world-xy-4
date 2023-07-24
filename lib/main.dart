import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flame/components.dart';

import 'package:worldxy04/components/playerComponent.dart';
import 'package:worldxy04/maps/tile_map_component.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final world = World();
  late final CameraComponent cameraComponent;

  @override
  void onLoad() {
    add(world);

    var background = TileMapComponent();
    world.add(background);

    background.loaded.then(
      (value) {
        var player = PlayerComponent(
            game: this,
            mapSize: background.tiledMap.size,
            posPlayer: background.posPlayer);

        cameraComponent = CameraComponent(world: world);
        cameraComponent.follow(player);
        cameraComponent.setBounds(Rectangle.fromLTRB(
            0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
        cameraComponent.viewfinder.anchor = Anchor.center;

        add(cameraComponent);

        cameraComponent.world.add(player);

        // camera.followComponent(player,
        //     worldBounds: Rect.fromLTRB(
        //         0, 0, background.tiledMap.size.x, background.tiledMap.size.y));

        // enemiesMap1.forEach((e) => add(SkeletonComponent(
        //     mapSize: background.tiledMap.size,
        //     movementTypes: e.movementEnemies,
        //     typeEnemyMovement: e.typeEnemyMovement)..position=Vector2.all(50)));
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
