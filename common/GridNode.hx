package common;

import polygonal.ds.Heapable;
import common.Entity;
import common.messages.GridNodeMessage;

class GridNode implements Heapable<GridNode> {
	public var x: Int;
	public var y: Int;
	public var solid = false;
	public var entity: Entity;

	// used during pathfinding
	public var position: Int;
	public var heuristic: Int;

	public function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public function compare(other: GridNode) {
		return other.heuristic - heuristic;
	}

	public function isOccupied() {
		return solid || entity != null;
	}

	public function toString() {
		return 'GridNode { $x, $y, $solid }';
	}

	public function toMessage() {
		var msg = new GridNodeMessage(x, y, solid ? 1 : 0);
		return msg;
	}

	public function load(msg: GridNodeMessage) {
		solid = msg.solid != 0;
	}

}
