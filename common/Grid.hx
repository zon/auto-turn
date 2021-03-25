package common;

import common.messages.GridMessage;
import common.messages.GridNodeMessage;
import udprotean.shared.UDProteanPeer;
import common.GridNode;
import common.TilemapData;
import haxe.xml.Access;
import sys.io.File;
import haxe.ds.Vector;
import common.Entity;
import common.Calc;

class Grid {
	public var width: Int;
	public var height: Int;
	public var nodes: Vector<GridNode>;

	public var onAddEntity: (entity: Entity) -> Void;
	public var onMoveEntity: (entity: Entity) -> Void;
	public var onRemoveEntity: (entity: Entity) -> Void;

	public function new(width: Int, height: Int) {
		this.width = width;
		this.height = height;
		nodes = new Vector<GridNode>(width * height);
		for (y in 0...height) {
			for (x in 0...width) {
				nodes[indexCoord(x, y)] = new GridNode(x, y);
			}
		}
	}

	public function get(x, y): Null<GridNode> {
		if (x < 0 || x >= width) return null;
		if (y < 0 || y >= height) return null;
		return nodes[indexCoord(x, y)];
	}

	public function isSolid(x, y) {
		var node = get(x, y);
		if (node == null) return true;
		return node.solid;
	}

	public function isOccupied(x, y) {
		var node = get(x, y);
		if (node == null) return true;
		return node.isOccupied();
	}

	public function addEntity(x: Int, y: Int, entity: Entity, signal = true) {
		var node = get(x, y);
		if (node.isOccupied()) {
			throw 'Node occupied';
		}
		entity.grid = this;
		entity.x = x;
		entity.y = y;
		node.entity = entity;
		if (signal && onAddEntity != null) onAddEntity(entity);
	}

	public function moveEntity(entity: Entity, x: Int, y: Int) {
		removeEntity(entity, false);
		addEntity(x, y, entity, false);
		if (onMoveEntity != null) onMoveEntity(entity);
	}

	public function removeEntity(entity: Entity, signal = true) {
		var node = get(entity.x, entity.y);
		if (node.entity == entity) {
			node.entity = null;
			entity.grid = null;
			if (signal && onRemoveEntity != null) onRemoveEntity(entity);
			return true;
		} else {
			return false;
		}
	}

	public function index(node: GridNode) {
		return indexCoord(node.x, node.y);
	}

	public function indexCoord(x: Int, y: Int) {
		return y * width + x;
	}

	public function raycast(ax: Int, ay: Int, bx: Int, by: Int): GridNode {
		var vx = bx - ax;
		var vy = by - ay;
		var n = Calc.normal(vx, vy);
		var nx = n.x;
		var ny = n.y;
		var sx = 1 / Math.abs(nx);
		var sy = 1 / Math.abs(ny);

		var tx = Math.floor(ax);
		var ty = Math.floor(ay);
		var tsx = nx < 0 ? -1 : 1;
		var tsy = ny < 0 ? -1 : 1;
		var gx = Math.floor(bx);
		var gy = Math.floor(by);

		var dx = 0.0;
		var dy = 0.0;
		if (nx >= 0) {
			dx = 1 - (ax % 1);
		} else {
			dx = ax % 1;
		}
		if (ny >= 0) {
			dy = 1 - (ay % 1);
		} else {
			dy = ay % 1;
		}
		dx = dx * sx;
		dy = dy * sy;

		var td = 0.0;
		var m = Calc.mag(vx, vy);
		var s = 0.0;
		var tile = get(tx, ty);
		var lx = ax * 1.0;
		var ly = ay * 1.0;
		while (td < m) {
			var s = s + 1;

			if (dx < dy) {
				td = td + dx;
				dy = dy - dx;
				dx = sx;
				tx = tx + tsx;
			} else {
				td = td + dy;
				dx = dx - dy;
				dy = sy;
				ty = ty + tsy;
			}

			var px = ax + nx * td;
			var py = ay + ny * td;
			lx = px;
			ly = py;

			var last = tile;
			tile = get(tx, ty);
			if (tile == null || tile.solid) {
				return last;

			} else if (tile.x == gx && tile.y == gy) {
				return tile;
			}
		}

		return tile;
	}

	public function send(peer: UDProteanPeer) {
		peer.send(toMessage());
		for (node in nodes) {
			peer.send(node.toMessage());
		}
	}

	public function toMessage() {
		return new GridMessage(width, height);
	}

	public function loadNode(msg: GridNodeMessage) {
		var i = indexCoord(msg.x, msg.y);
		nodes[i].load(msg);

		// true when last node is loaded
		return i + 1 >= nodes.length;
	}

	public static function parse(file) {
		var data = TilemapData.load(file);
		var grid = new Grid(data.width, data.height);
		for (y in 0...data.height) {
			for (x in 0...data.width) {
				grid.get(x, y).solid = data.get(x, y).solid;
			}
		}
		return grid;
	}

	public static function load(msg: GridMessage) {
		return new Grid(msg.width, msg.height);
	}

}
