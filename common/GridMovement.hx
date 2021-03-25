package common;

import common.Entity;
import common.GridNode;

class GridMovement {
	var entity: Entity;

	public var px = 0;
	public var py = 0;

	// stats
	public var actionDuration = 0.5;
	public var pauseDuration = 2;

	// state
	var path = new Array<GridNode>();

	public function new(entity: Entity) {
		this.entity = entity;
	}

	public function command(path: Array<GridNode>) {
		this.path = path;
	}

	public function move(node: GridNode) {
		if (node.isOccupied()) {
			reset();
			return;
		}

		px = entity.x;
		py = entity.y;
		entity.grid.moveEntity(entity, node.x, node.y);
		entity.startCooldown(actionDuration, pauseDuration);
		trace('Move ${entity.id}: ${entity.x}, ${entity.y}');
	}

	public function update(dt: Float) {
		if (path.length < 1 || !entity.isCool()) return;
		move(path.shift());
	}

	public function reset() {
		path = [];
	}

}
