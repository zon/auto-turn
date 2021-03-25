package server;

import haxe.io.Bytes;
import bytetype.ByteType;
import udprotean.server.UDProteanClientBehavior;
import common.Entity;
import common.messages.MoveCommand;

class ClientBehavior extends UDProteanClientBehavior {
	public var id: Int;
	public var dispatcher: Dispatcher;
	public var entity: Entity;

	override function onConnect() {
		dispatcher.onConnect(this);
	}

	override function onMessage(message: Bytes) {
		switch ByteType.getCode(message) {
			case MoveCommand.code:
				if (entity == null) return;
				dispatcher.onMoveCommand(entity, cast message);
		}
	}

	override function onDisconnect() {
		dispatcher.onDisconnect(this);
	}
 
}
