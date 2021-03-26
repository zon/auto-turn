package common;

import polygonal.ds.Heapable;
import common.Entity;

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

}
