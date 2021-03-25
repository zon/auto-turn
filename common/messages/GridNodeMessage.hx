package common.messages;

import haxe.io.Bytes;
import common.GridNode;

@:build(bytetype.ByteTypeBuilder.build())
abstract GridNodeMessage(Bytes) to Bytes {
	var x: Int;
	var y: Int;
	var solid: UInt;

	public static function create(node: GridNode) {
		return new GridNodeMessage(node.x, node.y, node.solid ? 1 : 0);
	}

}
