package server;

import common.messages.PlayerMessage;
import common.messages.EntityAddMessage;
import common.messages.EntityMoveMessage;
import common.messages.EntityRemoveMessage;
import common.messages.MoveCommand;
import common.Grid;
import common.Entity;
import server.Server;
import server.ServerGame;

class Dispatcher {
	public var game: ServerGame;
	public var server: Server;

	public function new() {
		game = new ServerGame();
		game.loadGrid(Grid.parse('entry.tmx'));

		server = new Server(this);

		game.grid.onAddEntity = onAddEntity;
		game.grid.onMoveEntity = onMoveEntity;
		game.grid.onRemoveEntity = onRemoveEntity;
	}

	public function start() {
		server.start();
	}

	public function onConnect(client: ClientBehavior) {
		client.send(new PlayerMessage(client.id));
		game.grid.send(client);
		for (entity in game.entities) {
			client.send(EntityAddMessage.create(entity));
		}
		client.entity = game.createEntity(8, 8, client.id);
	}

	public function onDisconnect(client: ClientBehavior) {
		if (client.entity == null) return;
		game.removeEntity(client.entity.id);
	}

	public function onMoveCommand(entity: Entity, command: MoveCommand) {
		trace('Move command ${command.x}, ${command.y}');
		var start = game.grid.get(entity.x, entity.y);
		var goal = game.grid.get(command.x, command.y);
		if (goal == null) {
			trace('Goal ${command.x}, ${command.y} not found');
			return;
		}
		var path = game.pathfinder.travel(start, goal);
		entity.movement.command(path);
	}

	function onAddEntity(entity: Entity) {
		sendAll(EntityAddMessage.create(entity));
	}

	function onMoveEntity(entity: Entity) {
		sendAll(EntityMoveMessage.create(entity));
	}

	function onRemoveEntity(entity: Entity) {
		sendAll(EntityRemoveMessage.create(entity));
	}

	public function update(dt: Float) {
		game.update(dt);
		server.update();
	}

	public function stop() {
		server.stop();
	}

	public function sendAll(message, sendNow = true) {
		server.sendAll(message, sendNow);
	}

	public function sendOthers(entityId, message, sendNow = true) {
		server.sendOthers(entityId, message, sendNow);
	}

	public function sendPlayer(playerId, message, sendNow = true) {
		server.sendPlayer(playerId, message, sendNow);
	}

}
