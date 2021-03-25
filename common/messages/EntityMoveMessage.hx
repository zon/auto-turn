package common.messages;

import haxe.io.Bytes;

@:build(bytetype.ByteTypeBuilder.build())
abstract EntityMoveMessage(Bytes) to Bytes {
	var id: Int;
	var x: Int;
	var y: Int;

	public function toString() {
		return 'EntityMoveMessage { $id, $x, $y }';
	}

	public static function create(entity: Entity) {
		return new EntityMoveMessage(entity.id, entity.x, entity.y);
	}

}
