package client.views;

import h2d.Object;
import client.ClientGame;
import client.views.ResMap;
import client.views.EntityView;
import common.Grid;
import common.Entity;

class EntitiesView extends Object {
	public var res: ResMap;
	public var entities = new Array<EntityView>();

	public function new(game: ClientGame, res, ?parent: Object) {
		super(parent);
		this.res = res;
		game.onGrid.push(onGrid);
	}

	function onGrid(grid: Grid) {
		for (entity in entities) {
			entity.remove();
		}
		entities = new Array<EntityView>();
		grid.onAddEntity = onAddEntity;
		grid.onRemoveEntity = onRemoveEntity;
	}

	function onAddEntity(entity: Entity) {
		var view = new EntityView(entity, res, this);
		entities.push(view);
	}

	function onRemoveEntity(entity: Entity) {
		for (i in 0...entities.length) {
			var view = entities[i];
			if (view.entity.id == entity.id) {
				view.remove();
				entities.slice(i, 1);
				return;
			}
		}
	}

	public function update() {
		for (entity in entities) {
			entity.update();
		}
	}

}
