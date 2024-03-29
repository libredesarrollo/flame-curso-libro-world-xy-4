import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:worldxy04/components/skeleton_component.dart';
import 'package:worldxy04/components/zombie_component.dart';
import 'package:worldxy04/helpers/enemy/movements.dart';

import 'package:worldxy04/maps/tile/object_component.dart';
import 'package:worldxy04/maps/tile/water_component.dart';

class TileMapComponent extends PositionComponent {
  late TiledComponent tiledMap;
  late Vector2 posPlayer;

  @override
  Future<void>? onLoad() async {
    tiledMap = await TiledComponent.load('map.tmx', Vector2.all(48));
    add(tiledMap);

    final objWater = tiledMap.tileMap.getLayer<ObjectGroup>('water_object');

    for (final obj in objWater!.objects) {
      add(WaterComponent(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y)));
    }

    final objObs = tiledMap.tileMap.getLayer<ObjectGroup>('obstacles_object');

    for (final obj in objObs!.objects) {
      add(ObjectComponent(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y)));
    }

    final enemyObjects =
        tiledMap.tileMap.getLayer<ObjectGroup>('enemies_object');

    for (var i = 0; i < enemyObjects!.objects.length; i++) {
      var e = enemiesMap1[i];
      if (e.typeEnemy == TypeEnemy.zombie) {
        add(ZombieComponent(
            mapSize: tiledMap.size,
            movementTypes: e.movementEnemies,
            typeEnemyMovement: e.typeEnemyMovement)
          ..position =
              Vector2(enemyObjects.objects[i].x, enemyObjects.objects[i].y));
      } else {
        add(SkeletonComponent(
            mapSize: tiledMap.size,
            movementTypes: e.movementEnemies,
            typeEnemyMovement: e.typeEnemyMovement)
          ..position =
              Vector2(enemyObjects.objects[i].x, enemyObjects.objects[i].y));
      }
    }

    // pos player
    final objPlayer = tiledMap.tileMap.getLayer<ObjectGroup>('player_object');
    posPlayer = Vector2(objPlayer!.objects[0].x, objPlayer.objects[0].y);
  }
}
