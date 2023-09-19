import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum MovementType {
  idle,
  walkingright,
  walkingleft,
  walkingup,
  walkingdown,
  runright,
  runleft,
  runup,
  rundown,
}

enum PlayerDirection { up, right, left, down }

class Character extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks {
  MovementType movementType = MovementType.idle;

  PlayerDirection playerDirection = PlayerDirection.down;

  PlayerDirection? playerCollisionDirection = null;
  PlayerDirection? playerCollisionDirectionTwo = null;

  double objectCollisionId = -1;
  double objectCollisionTwoId = -1;

  //bool objectCollision = false;
  // List<PlayerDirection> playerCollisionDirection = [];

  double speed = 80;
  // bool isMoving = false;

  double spriteSheetWidth = 32;
  double spriteSheetHeight = 32;

  late SpriteAnimation idleAnimation,
      leftAnimation,
      rightAnimation,
      upAnimation,
      downAnimation;

  late RectangleHitbox body;
}
