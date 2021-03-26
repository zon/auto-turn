package client.views;

import hxd.Res;
import h2d.Tile;
import common.TilesetData;

class Tileset {
	public var data: TilesetData;
	public var parent: Tile;
	
	var tiles: Array<Tile>;

	function new() {}

	public function get(index) {
		var i = data.get(index).id;
		return tiles[i];
	}

	public static function parse(data: TilesetData): Tileset {
		var set = new Tileset();
		set.data = data;
		set.parent = Res.load(data.image).toTile();
		set.tiles = set.parent.gridFlatten(data.tileWidth);
		return set;
	}

}
