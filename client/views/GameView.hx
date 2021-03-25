package client.views;

import h2d.Object;
import client.views.ResMap;
import client.views.GridView;
import client.views.EntitiesView;
import client.Console;
import client.ClientGame;
import common.Grid;

class GameView extends Object {
	public var game: ClientGame;
	public var res: ResMap;
	public var grid: GridView;
	public var entities: EntitiesView;
	public var console: Console;

	public function new(game, ?parent: Object) {
		super(parent);

		scale(View.pixel);

		this.game = game;

		res = new ResMap();
		grid = new GridView(res, this);
		entities = new EntitiesView(game, res, this);
		console = new Console(this);

		game.onGrid.push(onGrid);
	}

	public function update() {
		entities.update();
		console.update();
	}

	function onGrid(grid: Grid) {
		this.grid.load(grid);
	}

}
