package common;

import haxe.xml.Access;
import sys.io.File;

class TilesetData {
	public var file: String;
	public var first = 0;
	public var count: Int;
	public var tiles = new Map<Int, TilesetTile>();

	public function new() {}

	public function get(index) {
		var key = index + first;
		if (tiles.exists(key)) {
			return tiles[key];
		} else {
			return TilesetTile.empty;
		}
	}

	public static function load(file) {
		var text = File.getContent('./res/map/$file');
		var xml = Xml.parse(text);
		var data = new Access(xml.firstElement());
		var res = new TilesetData();
		res.file = file;
		res.count = Std.parseInt(data.att.tilecount);
		for (tile in data.nodes.tile) {
			if (
				!tile.has.id ||
				!tile.hasNode.properties
			) continue;
			var id = Std.parseInt(tile.att.id);
			var rt = new TilesetTile();
			var properties = tile.node.properties;
			for (prop in properties.nodes.property) {
				if (
					!prop.has.name ||
					!prop.has.type ||
					!prop.has.value
				) continue;
				if (
					prop.att.name == 'solid' &&
					prop.att.type == 'bool'
				) {
					rt.solid = prop.att.value == 'true';
					break;
				}
			}
			res.tiles[id] = rt;
		}
		return res;
	}

}

class TilesetTile {
	public var solid = false;

	public static var empty = new TilesetTile();

	public function new() {}
}
