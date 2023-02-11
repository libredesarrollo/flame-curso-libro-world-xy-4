import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worldxy04/main.dart';
import 'package:worldxy04/components/character.dart';
import 'package:worldxy04/maps/tile/object_component.dart';
import 'package:worldxy04/maps/tile/water_component.dart';
import 'package:worldxy04/utils/create_animation_by_limit.dart';

class PlayerComponent extends Character {
  MyGame game;
  Vector2 mapSize;
  Vector2 posPlayer;

  PlayerComponent(
      {required this.game, required this.mapSize, required this.posPlayer})
      : super() {
    debugMode = true;
  }

  @override
  Future<void>? onLoad() async {
    final spriteImage = await Flame.images.load('player.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 4, sizeX: 8, stepTime: .2);
    downAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 4, sizeX: 8, stepTime: .2);
    leftAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 0, step: 4, sizeX: 8, stepTime: .2);
    rightAnimation = spriteSheet.createAnimationByLimit(
        xInit: 2, yInit: 0, step: 4, sizeX: 8, stepTime: .2);
    upAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 4, sizeX: 8, stepTime: .2);

    body = RectangleHitbox(
        size: Vector2(spriteSheetWidth - 60, spriteSheetHeight - 40),
        position: Vector2(30, 20))..collisionType = CollisionType.active;

    add(body);
    reset();
    //return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      movementType = MovementType.idle;
      // isMoving = false;
    }
    // else {
    //   isMoving = true;
    // }

    //**** RIGHT
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      playerDirection = PlayerDirection.right;
      if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        // RUN
        movementType = MovementType.runright;
      } else {
        // WALKING
        movementType = MovementType.walkingright;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || //**** LEFT
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      playerDirection = PlayerDirection.left;
      if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        // RUN
        movementType = MovementType.runleft;
      } else {
        // WALKING
        movementType = MovementType.walkingleft;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp) || //**** TOP
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      playerDirection = PlayerDirection.up;
      if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        // RUN
        movementType = MovementType.runup;
      } else {
        // WALKING
        movementType = MovementType.walkingup;
      }
    } else if (keysPressed
            .contains(LogicalKeyboardKey.arrowDown) || //**** BOTTOM
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      playerDirection = PlayerDirection.down;
      if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        // RUN
        movementType = MovementType.rundown;
      } else {
        // WALKING
        movementType = MovementType.walkingdown;
      }
    }

    return true;
  }

  void moveAnimation(double delta) {
    // if (!isMoving) return;

    movePlayer(delta);

    switch (movementType) {
      case MovementType.walkingright:
      case MovementType.runright:
        _resetAnimation();
        animation = rightAnimation;
        break;
      case MovementType.walkingleft:
      case MovementType.runleft:
        _resetAnimation();
        animation = leftAnimation;
        break;
      case MovementType.walkingup:
      case MovementType.runup:
        _resetAnimation();
        animation = upAnimation;
        break;
      case MovementType.walkingdown:
      case MovementType.rundown:
        _resetAnimation();
        animation = downAnimation;
        break;
      default: // idle
        animation?.loop = false;
        //animation = idleAnimation;
        break;
    }
  }

  void _resetAnimation() {
    if (animation?.loop == false) {
      animation?.loop = true;
      animation?.reset();
    }
  }

  void movePlayer(double delta) {
    // if (playerDirection == playerCollisionDirection) {
    //   return;
    // }

    // if (playerCollisionDirection.contains(playerDirection)) {
    //   return;
    // }

    if (!(playerCollisionDirection == playerDirection ||
        playerCollisionDirectionTwo == playerDirection)) {
      switch (movementType) {
        case MovementType.walkingright:
        case MovementType.runright:
          // if (playerCollisionDirection.isNotEmpty &&
          //     playerCollisionDirection[0] == PlayerDirection.right) {
          //   // nada
          // } else {
          //   position.add(Vector2(delta * speed, 0));
          // }
          if (position.x < mapSize.x - size.x) {
            position.add(Vector2(delta * speed * (movementType == MovementType.runright ? 3 : 1), 0));
          }

          break;
        case MovementType.walkingleft:
        case MovementType.runleft:
          // if (playerCollisionDirection.isNotEmpty &&
          //     playerCollisionDirection[0] == PlayerDirection.left) {
          //   // nada
          // } else {
          //   position.add(Vector2(delta * -speed, 0));
          // }

          if (position.x > 0) {
            position.add(Vector2(delta * -speed * (movementType == MovementType.runleft ? 3 : 1), 0));
          }

          break;
        case MovementType.walkingup:
        case MovementType.runup:
          // if (playerCollisionDirection.isNotEmpty &&
          //     playerCollisionDirection[0] == PlayerDirection.up) {
          //   // nada
          // } else {
          //   position.add(Vector2(0, delta * -speed));
          // }
          if (position.y > 0) {
            position.add(Vector2(0, delta * -speed* (movementType == MovementType.runup ? 3 : 1)));
          }
          break;
        case MovementType.walkingdown:
        case MovementType.rundown:
          // if (playerCollisionDirection.isNotEmpty &&
          //     playerCollisionDirection[0] == PlayerDirection.down) {
          //   // nada
          // } else {
          //   position.add(Vector2(0, delta * speed));
          // }
          if (position.y < mapSize.y - size.y) {
            position.add(Vector2(0, delta * speed* (movementType == MovementType.rundown ? 3 : 1)));
          }
          break;
        case MovementType.idle:
          break;
      }
    }
  }

  void reset() {
    animation = idleAnimation;
    // position = Vector2(spriteSheetWidth, spriteSheetHeight - 130);
    position = posPlayer;
    size = Vector2(spriteSheetWidth, spriteSheetHeight);
    // size = Vector2.all(30);
    movementType = MovementType.idle;
  }

  @override
  void update(double delta) {
    moveAnimation(delta);
    super.update(delta);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is WaterComponent || other is ObjectComponent) {
      //quinta implementacion doble colision
      if (objectCollisionId == -1) {
        // primera colision
        playerCollisionDirection = playerDirection;
        objectCollisionId = other.position.x;
        print(
            "Primera colsion ${playerCollisionDirection} ${playerCollisionDirectionTwo} ${objectCollisionId} ${objectCollisionTwoId}");
      } else if (objectCollisionTwoId == -1 &&
          objectCollisionId != other.position.x) {
        playerCollisionDirectionTwo = playerDirection;
        objectCollisionTwoId = other.position.x;
        print(
            "Segunda colsion ${playerCollisionDirection} ${playerCollisionDirectionTwo} ${objectCollisionId} ${objectCollisionTwoId}");
      }

      // if (playerCollisionDirection == null) {
      //   playerCollisionDirection = playerDirection;
      //   //objectCollision = true;
      // }
      // playerCollisionDirection = playerDirection;
      // if (!playerCollisionDirection.contains(playerDirection)) {
      //   playerCollisionDirection.add(playerDirection);
      // }
    }

    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is WaterComponent || other is ObjectComponent) {
      playerCollisionDirection = null;
      //objectCollision = false;
      //playerCollisionDirection = [];

      if (objectCollisionId == other.position.x) {
        // se fue la primera colision
        objectCollisionId = objectCollisionTwoId;
        playerCollisionDirection = playerCollisionDirectionTwo;

        // se fue la segunda colision
        playerCollisionDirectionTwo = null;
        objectCollisionTwoId = -1;
        print(
            "Se fue la primera colsion ${playerCollisionDirection} ${playerCollisionDirectionTwo} ${objectCollisionId} ${objectCollisionTwoId}");
      } else if (objectCollisionTwoId == other.position.x) {
        // se fue la segunda colision
        playerCollisionDirectionTwo = null;
        objectCollisionTwoId = -1;
        print(
            "Se fue la segunda colsion ${playerCollisionDirection} ${playerCollisionDirectionTwo} ${objectCollisionId} ${objectCollisionTwoId}");
      }
    }

    super.onCollisionEnd(other);
  }
}
