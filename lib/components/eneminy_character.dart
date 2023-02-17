import 'dart:math';

import 'package:worldxy04/components/character.dart';
import 'package:worldxy04/helpers/enemy/movements.dart';

class EnemyCharacter extends Character {
  EnemyCharacter(this.typeEnemyMovement, this.movementTypes);

  TypeEnemyMovement typeEnemyMovement;
  List<PlayerDirection> movementTypes;
  int newDirection = -1;

  void changeDirection() {
    if(typeEnemyMovement == TypeEnemyMovement.random){
      _changeDirectionRandom();
    }else{
      _changeDirectionPattern();
    }
  }

  void _changeDirectionRandom() {
    Random random = Random();

    newDirection = random.nextInt(4); // 0 1 2 3

    if (newDirection == 0) {
      animation = downAnimation;
      playerDirection = PlayerDirection.down;
    } else if (newDirection == 1) {
      animation = upAnimation;
      playerDirection = PlayerDirection.up;
    } else if (newDirection == 2) {
      animation = leftAnimation;
      playerDirection = PlayerDirection.left;
    } else if (newDirection == 3) {
      animation = rightAnimation;
      playerDirection = PlayerDirection.right;
    }
  }

  void _changeDirectionPattern() {
    newDirection++;

    if (newDirection >= movementTypes.length) {
      newDirection = 0;
    }

    playerDirection = movementTypes[newDirection];

    if (playerDirection == PlayerDirection.up) {
      animation = upAnimation;
    } else if (playerDirection == PlayerDirection.down) {
      animation = downAnimation;
    } else if (playerDirection == PlayerDirection.right) {
      animation = rightAnimation;
    } else if (playerDirection == PlayerDirection.left) {
      animation = leftAnimation;
    }
  }
}
