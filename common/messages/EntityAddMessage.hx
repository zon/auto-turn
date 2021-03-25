package common.messages;

import haxe.io.Bytes;
import common.Entity;

@:build(bytetype.ByteTypeBuilder.build())
abstract EntityAddMessage(Bytes) to Bytes {
	var id: Int;
	var playerId: Int;
	var x: Int;
	var y: Int;

	public function toEntity() {
		var e = new Entity(id, playerId);
		e.x = x;
		e.y = y;
		return e;
	}

	public static function create(entity: Entity) {
		return new EntityAddMessage(entity.id, entity.playerId, entity.x, entity.y);
	}

}
