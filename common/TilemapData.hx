package common;

import haxe.io.Path;
import haxe.xml.Access;
import sys.io.File;
import common.TilesetData;
import common.TilesetData.TilesetTile;
import haxe.ds.Vector;

class TilemapData {
	public var name: String;
	public var width: Int;
	public var height: Int;
	public var tileWidth: Int;
	public var tileHeight: Int;
	public var tilesets = new Map<String, TilesetData>();
	public var layers = new Map<String, TilemapLayer>();

	public function new () {}

	public function getTileset(name = 'walls') {
		return tilesets.get(name);
	}

	public function getLayer(name = 'walls') {
		return layers.get(name);
	}

	public function get(x: Int, y: Int, layer = 'walls'): TilesetTile {
		if (!layers.exists(layer)) return TilesetTile.empty;
		var tiles = layers[layer].tiles;
		var id = tiles[y * width + x];
		return findById(id);
	}

	public function findById(id: Int): TilesetTile {
		for (tileset in tilesets) {
			if (id >= tileset.firstGid && id < tileset.firstGid + tileset.tileCount) {
				return tileset.get(id);
			}
		}
		return TilesetTile.empty;
	}

	public function getSpawn() {
		var tile = 0;
		var tileset = getTileset();

	}

	public static function parse(name) {
		var text = File.getContent('./res/map/$name.tmx');
		var xml = Xml.parse(text);
		var root = new Access(xml.firstElement());

		var res = new TilemapData();
		res.name = name;
		res.width = Std.parseInt(root.att.width);
		res.height = Std.parseInt(root.att.height);
		res.tileWidth = Std.parseInt(root.att.tilewidth);
		res.tileHeight = Std.parseInt(root.att.tileheight);

		for (tileset in root.nodes.tileset) {
			var rs = TilesetData.parse(Path.withoutExtension(tileset.att.source));
			rs.firstGid = Std.parseInt(tileset.att.firstgid);
			res.tilesets[rs.name] = rs;
		}

		for (layer in root.nodes.layer) {
			var rl = new TilemapLayer();
			rl.id = Std.parseInt(layer.att.id);
			rl.name = layer.att.name;
			rl.tiles = new Vector<Int>(res.width * res.height);
			var tids = layer.node.data.innerData.split(',');
			for (i in 0...rl.tiles.length) {
				var tid = Std.parseInt(tids[i]);
				var tile = res.findById(tid);
				rl.tiles[i] = tid;
				if (tile.spawn) rl.spawns.push(i);
			}
			res.layers[rl.name] = rl;
		}

		return res;
	}

}

class TilemapLayer {
	public var id: Int;
	public var name: String;
	public var tiles: Vector<Int>;
	public var spawns = new Array<Int>();

	public function new() {}
}
