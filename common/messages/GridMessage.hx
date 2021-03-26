package common.messages;

import haxe.io.Bytes;

@:build(bytetype.ByteTypeBuilder.build())
abstract GridMessage(Bytes) to Bytes {
	@length(8) var name: String;
}
