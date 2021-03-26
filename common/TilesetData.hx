package common;

import sys.FileSystem;
import haxe.io.Path;
import haxe.ds.Vector;
import haxe.xml.Access;
import sys.io.File;

class TilesetData {
	public var name: String;
	public var image: String;
	public var tileWidth: Int;
	public var tileHeight: Int;
	public var tileCount: Int;
	public var columns: Int;
	public var tiles: Vector<TilesetTile>;
	public var firstGid: Int;

	public function new() {}

	public function getIndex(index: Int) {
		return index - firstGid;
	}

	public function get(index: Int) {
		var i = getIndex(index);
		if (i >= 0 && i < tileCount) {
			return tiles[i];
		} else {
			return TilesetTile.empty;
		}
	}

	public static function parse(name) {
		var path = FileSystem.absolutePath('res/map/$name.tsx');
		var text = File.getContent(path);
		var xml = Xml.parse(text);
		var data = new Access(xml.firstElement());
		var res = new TilesetData();
		res.name = name;
		res.image = Path.withoutDirectory(data.node.image.att.source);
		res.tileWidth = Std.parseInt(data.att.tilewidth);
		res.tileHeight = Std.parseInt(data.att.tileheight);
		res.tileCount = Std.parseInt(data.att.tilecount);
		res.columns = Std.parseInt(data.att.columns);
		res.tiles = new Vector(res.tileCount);
		for (i in 0...res.tileCount) {
			res.tiles[i] = new TilesetTile(i);
		}
		for (t in data.nodes.tile) {
			var id = Std.parseInt(t.att.id);
			var tile = res.tiles[id];
			var properties = t.node.properties;
			for (prop in properties.nodes.property) {
				if (!isProp(prop)) continue;
				switch (prop.att.name) {
					case 'solid':
						tile.solid = getBool(prop);
					case 'spawn':
						tile.spawn = getBool(prop);
				}
			}
		}
		return res;
	}

	static function isProp(node: Access) {
		return
			node.has.name &&
			node.has.type &&
			node.has.value;
	}

	static function getBool(node: Access) {
		return node.att.value == 'true';
	}

}

class TilesetTile {
	public var id: Int;
	public var solid = false;
	public var spawn = false;

	public static var empty = new TilesetTile(0);

	public function new(id) {
		this.id = id;
	}
}
