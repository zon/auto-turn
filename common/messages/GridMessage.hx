package common.messages;

import haxe.io.Bytes;
import common.Grid;

@:build(bytetype.ByteTypeBuilder.build())
abstract GridMessage(Bytes) to Bytes {
	var width: Int;
	var height: Int;

	public static function create(grid: Grid) {
		return new GridMessage(grid.width, grid.height);
	}

}
