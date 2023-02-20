import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'package:worldxy04/components/character.dart';
import 'package:worldxy04/components/enemy_character.dart';
import 'package:worldxy04/maps/tile/object_component.dart';
import 'package:worldxy04/maps/tile/water_component.dart';
import 'package:worldxy04/utils/create_animation_by_limit.dart';

class SkeletonComponent extends EnemyCharacter {
  double elapseTime = 0;
  Vector2 mapSize;

  SkeletonComponent({required this.mapSize, required typeEnemyMovement, required movementTypes}) : super(typeEnemyMovement, movementTypes) {
    debugMode = true;
  }

  @override
  Future<void>? onLoad() async {
    spriteSheetWidth = 32;
    spriteSheetHeight = 64;
    final spriteImage = await Flame.images
        .load('zombie_skeleton.png'); //288 × 256    - 288/9 = 32 x 256/4 64
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 3, step: 6, sizeX: 9, stepTime: .2);
    downAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 3, step: 6, sizeX: 9, stepTime: .2);
    leftAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 3, step: 6, sizeX: 9, stepTime: .2);
    rightAnimation = spriteSheet.createAnimationByLimit(
        xInit: 2, yInit: 3, step: 6, sizeX: 9, stepTime: .2);
    upAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 3, step: 6, sizeX: 9, stepTime: .2);

    body = RectangleHitbox(
        size: Vector2(
          spriteSheetWidth,
          spriteSheetHeight - 10,
        ),
        position: Vector2(0, 10))
      ..collisionType = CollisionType.active;

    add(body);
    reset();
    //return super.onLoad();
  }

  void reset() {
    animation = idleAnimation;
    //position = Vector2(300, 300);

    size = Vector2(spriteSheetWidth, spriteSheetHeight);
    // size = Vector2.all(30);
    movementType = MovementType.idle;
  }

  @override
  void update(double dt) {
    elapseTime += dt;

    if (elapseTime > 2.0) {
      changeDirection();
      elapseTime = 0;
    }
    if (playerCollisionDirection != playerDirection) {
      switch (playerDirection) {
        case PlayerDirection.down:
          if (position.y < mapSize.y) {
            position.y += speed * dt;
          }
          break;
        case PlayerDirection.up:
          if (position.y > 0) {
            position.y -= speed * dt;
          }
          break;
        case PlayerDirection.left:
          if (position.x > 0) {
            position.x -= speed * dt;
          }
          break;
        case PlayerDirection.right:
          if (position.x < mapSize.x) {
            position.x += speed * dt;
          }
          break;
      }
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is WaterComponent || other is ObjectComponent) {
      if (playerCollisionDirection == null) {
        playerCollisionDirection = playerDirection;
      }
    }

    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is WaterComponent || other is ObjectComponent) {
      playerCollisionDirection = null;
    }
    super.onCollisionEnd(other);
  }
}
