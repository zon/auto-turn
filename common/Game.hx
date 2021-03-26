package common;

import common.Grid;
import common.Pathfinder;
import common.Entity;
import common.TilemapData;

class Game {
	public var grid: Grid;
	public var pathfinder: Pathfinder;
	public var entities = new Map<Int, Entity>();

	public var onTilemap = new Array<(data: TilemapData) -> Void>();
	public var onGrid = new Array<(grid: Grid) -> Void>();

	public function new() {}

	public function parseGrid(name) {
		var data = TilemapData.parse(name);
		grid = Grid.load(data);
		pathfinder = new Pathfinder(grid);
		entities = new Map<Int, Entity>();
		for (listener in onTilemap) {
			listener(data);
		}
		for (listener in onGrid) {
			listener(grid);
		}
	}

	public function addEntity(x, y, entity: Entity) {
		entities[entity.id] = entity;
		grid.addEntity(x, y, entity);
		return entity;
	}

	public function getEntity(id: Int): Null<Entity> {
		return entities.get(id);
	}

	public function moveEntity(id: Int, x: Int, y: Int) {
		var entity = getEntity(id);
		var node = grid.get(x, y);
		entity.movement.move(node);
	}

	public function removeEntity(id: Int) {
		var entity = getEntity(id);
		if (entity == null) return false;
		return grid.removeEntity(entity);
	}

}
