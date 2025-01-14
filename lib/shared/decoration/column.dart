import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:example/manual_map/dungeon_map.dart';
import 'package:example/shared/util/common_sprite_sheet.dart';

class ColumnDecoration extends GameDecoration with ObjectCollision {
  ColumnDecoration(Vector2 position)
      : super.withSprite(
          CommonSpriteSheet.columnSprite,
          position: position,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize * 3,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(DungeonMap.tileSize * 0.8, DungeonMap.tileSize / 2),
            align:
                Vector2(DungeonMap.tileSize * 0.1, DungeonMap.tileSize * 1.8),
          ),
        ],
      ),
    );
  }
}
