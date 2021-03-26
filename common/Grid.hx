package common;

import common.messages.GridMessage;
import common.GridNode;
import common.TilemapData;
import haxe.ds.Vector;
import common.Entity;
import common.Calc;

class Grid {
	public var name: String;
	public var width: Int;
	public var height: Int;
	public var nodes: Vector<GridNode>;
	public var spawns: Array<GridNode>;

	public var onAddEntity: (entity: Entity) -> Void;
	public var onMoveEntity: (entity: Entity) -> Void;
	public var onRemoveEntity: (entity: Entity) -> Void;

	public function new(name, width, height) {
		this.name = name;
		this.width = width;
		this.height = height;
		nodes = new Vector<GridNode>(width * height);
		for (y in 0...height) {
			for (x in 0...width) {
				nodes[indexCoord(x, y)] = new GridNode(x, y);
			}
		}
		spawns = [];
	}

	public function get(x, y): Null<GridNode> {
		if (x < 0 || x >= width) return null;
		if (y < 0 || y >= height) return null;
		return nodes[indexCoord(x, y)];
	}

	public function getSpawn() {
		for (node in spawns) {
			return getOpenNearby(node.x, node.y);
		}
		return null;
	}

	// https://stackoverflow.com/a/3706260
	public function getOpenNearby(x, y): Null<GridNode> {
		var vx = 1;
		var vy = 0;
		var len = 1;
		var ox = 0;
		var oy = 0;
		var p = 0;
		for (_ in 0...64) {

			var node = get(x + ox, y + oy);
			if (node != null && !node.isOccupied()) return node;

			ox += vx;
			oy += vy;
			p += 1;
			if (p >= len) {
				p = 0;
				var f = vx;
				vx = -vy;
				vy = f;
				if (vy == 0) {
					len += 1;
				}
			}
		}
		return null;
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

	public function toMessage() {
		return new GridMessage(name);
	}

	public static function parse(name) {
		var data = TilemapData.parse(name);
		return load(data);
	}

	public static function load(data: TilemapData) {
		var grid = new Grid(data.name, data.width, data.height);
		for (y in 0...data.height) {
			for (x in 0...data.width) {
				grid.get(x, y).solid = data.get(x, y).solid;
			}
		}
		for (layer in data.layers) {
			for (index in layer.spawns) {
				var x = index % grid.width;
				var y = Math.floor(index / grid.width);
				grid.spawns.push(grid.get(x, y));
			}
		}
		return grid;
	}

}
