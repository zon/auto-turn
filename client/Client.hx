package client;

import common.Grid;
import haxe.io.Bytes;
import bytetype.ByteType;
import udprotean.client.UDProteanClient;
import common.messages.*;
import common.Player;
import client.Dispatcher;
import client.Console;

class Client extends UDProteanClient {
	public var dispatcher: Dispatcher;
	public var player: Player;

	var loadingGrid: Grid;

	override function onConnect() {
		trace('Connected');
	}

	override function onMessage(message:Bytes) {
		switch ByteType.getCode(message) {

			case PlayerMessage.code:
				var m: PlayerMessage = cast message;
				player = Player.parse(m);
				trace('Player '+ player.id);

			case GridMessage.code:
				var m: GridMessage = cast message;
				loadingGrid = new Grid(m.width, m.height);

			case GridNodeMessage.code:
				var m: GridNodeMessage = cast message;
				if (loadingGrid.loadNode(m)) {
					dispatcher.onGridMessage(loadingGrid);
					loadingGrid = null;
				}

			case EntityAddMessage.code:
				var m: EntityAddMessage = cast message;
				dispatcher.onAddEntityMessage(m);

			case EntityMoveMessage.code:
				var m: EntityMoveMessage = cast message;
				dispatcher.onMoveEntityMessage(m);

			case EntityRemoveMessage.code:
				var m: EntityRemoveMessage = cast message;
				dispatcher.onRemoveEntityMessage(m);
		} 
	}

	override function onDisconnect() {
		trace('Disconnected');
		Sys.exit(0);
	}

	public function sendMove(x: Int, y: Int) {
		send(new MoveCommand(x, y), false);
	}

	function isPlayer(id: Int) {
		return player != null && id == player.id;
	}

}
