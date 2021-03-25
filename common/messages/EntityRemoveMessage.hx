package common.messages;

import haxe.io.Bytes;
import common.Entity;

@:build(bytetype.ByteTypeBuilder.build())
abstract EntityRemoveMessage(Bytes) to Bytes {
	var id: Int;

	public static function create(entity: Entity) {
		return new EntityRemoveMessage(entity.id);
	}

}
