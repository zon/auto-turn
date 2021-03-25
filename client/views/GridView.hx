package client.views;

import h2d.Object;
import common.Grid;
import h2d.TileGroup;
import client.views.View;

class GridView extends TileGroup {
	public var res: ResMap;
	public var grid: Grid;

	public function new(res: ResMap, ?parent: Object) {
		this.res = res;
		super(res.general, parent);
	}

	public function load(grid: Grid) {
		this.grid = grid;
		clear();
		for (node in grid.nodes) {
			var tile = node.solid ? res.getTile(1) : res.getTile(0);
			var x = node.x * View.unit;
			var y = node.y * View.unit;
			add(x, y, tile);
		}
	}

}
