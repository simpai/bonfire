import 'dart:math';
import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/collision/object_collision.dart';
import 'package:bonfire/util/direction.dart';
import 'package:bonfire/util/vector2rect.dart';

mixin Movement on GameComponent {
  bool isIdle = true;
  double dtUpdate = 0;
  double speed = 100;
  Direction lastDirection = Direction.right;
  Direction lastDirectionHorizontal = Direction.right;

  /// Move player to Up
  void moveUp(double speed, {VoidCallback? onCollision}) {
    double innerSpeed = speed * dtUpdate;
    Vector2Rect displacement = position.translate(0, (innerSpeed * -1));

    if (_isCollision(displacement)) {
      onCollision?.call();
      return;
    }

    isIdle = false;
    position = displacement;
    lastDirection = Direction.up;
  }

  /// Move player to Down
  void moveDown(double speed, {VoidCallback? onCollision}) {
    double innerSpeed = speed * dtUpdate;
    Vector2Rect displacement = position.translate(0, innerSpeed);

    if (_isCollision(displacement)) {
      onCollision?.call();
      return;
    }

    isIdle = false;
    position = displacement;
    lastDirection = Direction.down;
  }

  /// Move player to Left
  void moveLeft(double speed, {VoidCallback? onCollision}) {
    double innerSpeed = speed * dtUpdate;
    Vector2Rect displacement = position.translate((innerSpeed * -1), 0);

    if (_isCollision(displacement)) {
      onCollision?.call();
      return;
    }

    isIdle = false;
    position = displacement;
    lastDirection = Direction.left;
    lastDirectionHorizontal = Direction.left;
  }

  /// Move player to Right
  void moveRight(double speed, {VoidCallback? onCollision}) {
    double innerSpeed = speed * dtUpdate;
    Vector2Rect displacement = position.translate(innerSpeed, 0);

    if (_isCollision(displacement)) {
      onCollision?.call();
      return;
    }

    isIdle = false;
    position = displacement;
    lastDirection = Direction.right;
    lastDirectionHorizontal = Direction.right;
  }

  /// Move player to Up and Right
  void moveUpRight(double speedX, double speedY, {VoidCallback? onCollision}) {
    moveRight(speedX, onCollision: onCollision);
    moveUp(speedY, onCollision: onCollision);
    lastDirection = Direction.upRight;
  }

  /// Move player to Up and Left
  void moveUpLeft(double speedX, double speedY, {VoidCallback? onCollision}) {
    moveLeft(speedX, onCollision: onCollision);
    moveUp(speedY, onCollision: onCollision);
    lastDirection = Direction.upLeft;
  }

  /// Move player to Down and Left
  void moveDownLeft(double speedX, double speedY, {VoidCallback? onCollision}) {
    moveLeft(speedX, onCollision: onCollision);
    moveDown(speedY, onCollision: onCollision);
    lastDirection = Direction.downLeft;
  }

  /// Move player to Down and Right
  void moveDownRight(double speedX, double speedY,
      {VoidCallback? onCollision}) {
    moveRight(speedX, onCollision: onCollision);
    moveDown(speedY, onCollision: onCollision);
    lastDirection = Direction.downRight;
  }

  /// Move Player to direction by radAngle
  void moveFromAngle(double speed, double angle, {VoidCallback? onCollision}) {
    double nextX = (speed * dtUpdate) * cos(angle);
    double nextY = (speed * dtUpdate) * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase = Offset(
          position.rect.center.dx + nextPoint.dx,
          position.rect.center.dy + nextPoint.dy,
        ) -
        position.rect.center;

    Offset newDiffBase = diffBase;

    Vector2Rect newPosition = position.shift(newDiffBase);

    if (_isCollision(newPosition)) {
      onCollision?.call();
      return;
    }

    isIdle = false;
    position = newPosition;
  }

  void idle() {
    isIdle = true;
  }

  @override
  void update(double dt) {
    dtUpdate = dt;
    super.update(dt);
  }

  bool _isCollision(Vector2Rect displacement) {
    if (this.isObjectCollision()) {
      (this as ObjectCollision)
          .setCollisionOnlyVisibleScreen(this.isVisibleInCamera());
      return (this as ObjectCollision).isCollision(
        displacement: displacement,
      );
    } else {
      return false;
    }
  }
}
