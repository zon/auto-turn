package client.views;

import common.TilemapData;
import h2d.Object;
import h2d.TileGroup;

class GridView extends Object {
	public var res: ResMap;

	public function new(res: ResMap, ?parent: Object) {
		this.res = res;
		super(parent);
	}

	public function load(data: TilemapData) {
		removeChildren();
		var layer = data.getLayer('walls');
		var tileset = res.get(data.getTileset('walls'));
		var group = new TileGroup(tileset.parent, this);
		for (y in 0...data.width) {
			for (x in 0...data.height) {
				var i = data.width * y + x;
				var px = x * data.tileWidth;
				var py = y * data.tileHeight;
				var tile = tileset.get(layer.tiles[i]);
				group.add(px, py, tile);
			}
		}
	}

}
