import 'package:worldxy04/components/character.dart';

enum TypeEnemy { zombie, skeleton }

enum TypeEnemyMovement { random, pattern }

class BehaviorEnemy {
  BehaviorEnemy(
      {this.movementEnemies = const [],
      required this.typeEnemyMovement,
      required this.typeEnemy});

  List<PlayerDirection> movementEnemies;
  TypeEnemyMovement typeEnemyMovement;
  TypeEnemy typeEnemy;
}

List<BehaviorEnemy> enemiesMap1 = [
  BehaviorEnemy(
      typeEnemyMovement: TypeEnemyMovement.random, typeEnemy: TypeEnemy.zombie),
  BehaviorEnemy(
      typeEnemyMovement: TypeEnemyMovement.pattern,
      typeEnemy: TypeEnemy.zombie,
      movementEnemies: [
        PlayerDirection.right,
        PlayerDirection.right,
        PlayerDirection.down,
        PlayerDirection.left,
        PlayerDirection.down,
        PlayerDirection.up,
      ]),
  BehaviorEnemy(
      typeEnemyMovement: TypeEnemyMovement.pattern,
      typeEnemy: TypeEnemy.zombie,
      movementEnemies: [
        PlayerDirection.right,
        PlayerDirection.left
      ]),
];
