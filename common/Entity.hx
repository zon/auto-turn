package common;

import common.Grid;
import common.GridMovement;

class Entity {
	public var id: Int;
	public var playerId: Int;
	public var grid: Grid;
	public var movement: GridMovement;
	public var x = 0;
	public var y = 0;
	public var actionCooldown = 0.0;
	public var pauseCooldown = 0.0;

	public function new(id, playerId) {
		this.id = id;
		this.playerId = playerId;
		movement = new GridMovement(this);
	}

	public function isCool() {
		return actionCooldown <= 0 && pauseCooldown <= 0;
	}

	public function isActing() {
		return actionCooldown > 0;
	}

	public function startCooldown(action: Float, turn: Float) {
		actionCooldown = action;
		pauseCooldown = turn;
	}

	public function update(dt: Float) {
		if (actionCooldown > 0) {
			actionCooldown = Math.max(actionCooldown - dt, 0);
		} else {
			pauseCooldown = Math.max(pauseCooldown - dt, 0);
		}
	}

}
