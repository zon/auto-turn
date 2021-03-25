package client;

import common.messages.MoveCommand;
import common.messages.EntityRemoveMessage;
import common.messages.EntityAddMessage;
import common.messages.EntityMoveMessage;
import common.Grid;
import common.Config;
import common.Entity;
import client.Main;
import client.Input;
import client.Client;
import client.ClientGame;
import client.views.GameView;

class Dispatcher {
	public var client: Client;
	public var game: ClientGame;
	public var view: GameView;
	public var input: Input;

	public function new(app: Main) {
		client = new Client(Config.host, Config.port);
		client.dispatcher = this;
		game = new ClientGame();
		view = new GameView(game, app.s2d);
		input = new Input(app.s2d, this);
	}

	public function init() {
		client.connect();
	}

	public function update(dt: Float) {
		game.update(dt);
		view.update();
		// input.update();
		client.update();
	}

	public function dispose() {
		client.disconnect();
	}

	public function onGridMessage(grid: Grid) {
		game.loadGrid(grid);
	}

	public function onAddEntityMessage(msg: EntityAddMessage) {
		game.addEntity(msg.x, msg.y, msg.toEntity());
	}

	public function onMoveEntityMessage(msg: EntityMoveMessage) {
		game.moveEntity(msg.id, msg.x, msg.y);
	}

	public function onRemoveEntityMessage(msg: EntityRemoveMessage) {
		game.removeEntity(msg.id);
	}

	public function sendMove(x: Int, y: Int) {
		client.sendMove(x, y);
	}

}
