package common.messages;

import haxe.io.Bytes;

@:build(bytetype.ByteTypeBuilder.build())
abstract MoveCommand(Bytes) to Bytes {
	var x: Int;
	var y: Int;

	public function toString() {
		return 'MoveCommand {$x, $y}';
	}

}
