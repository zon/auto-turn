package common.messages;

import haxe.io.Bytes;

@:build(bytetype.ByteTypeBuilder.build())
abstract PlayerMessage(Bytes) to Bytes {
	var id: Int;
}
