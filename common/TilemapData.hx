package common;

import haxe.xml.Access;
import sys.io.File;
import common.TilesetData;
import common.TilesetData.TilesetTile;
import haxe.ds.Vector;

class TilemapData {
	public var file: String;
	public var width: Int;
	public var height: Int;
	public var tilesets = new Array<TilesetData>();
	public var layers = new Map<Int, TilemapLayer>();

	public function new () {}

	public function get(x: Int, y: Int, layerId = 0): TilesetTile {
		if (!layers.exists(layerId)) return TilesetTile.empty;
		var layer = layers[layerId];
		var id = layer.tiles[y * width + x];
		for (tileset in tilesets) {
			if (id >= tileset.first && id < tileset.first + tileset.count) {
				return tileset.get(id);
			}
		}
		return TilesetTile.empty;
	}

	public static function load(file) {
		var text = File.getContent('./res/map/$file');
		var xml = Xml.parse(text);
		var root = new Access(xml.firstElement());

		var res = new TilemapData();
		res.file = file;
		res.width = Std.parseInt(root.att.width);
		res.height = Std.parseInt(root.att.height);

		for (tileset in root.nodes.tileset) {
			var rs = TilesetData.load(tileset.att.source);
			rs.first = Std.parseInt(tileset.att.firstgid) - 1;
			res.tilesets.push(rs);
		}

		for (layer in root.nodes.layer) {
			var rl = new TilemapLayer();
			rl.tiles = new Vector<Int>(res.width * res.height);
			var tids = layer.node.data.innerData.split(',');
			for (i in 0...rl.tiles.length) {
				rl.tiles[i] = Std.parseInt(tids[i]) - 1;
			}
			var id = Std.parseInt(layer.att.id) - 1;
			res.layers[id] = rl;
		}

		return res;
	}

}

class TilemapLayer {
	public var tiles: Vector<Int>;

	public function new() {}
}
