package client.views;

import hxd.Res;
import common.TilesetData;
import client.views.View;
import client.views.Tileset;

class ResMap {
	public var entities: SpriteFrames;

	var tilesets = new Map<String, Tileset>();

	public function new() {
		Res.initEmbed();
		entities = new SpriteFrames('entities');
	}

	public function get(data: TilesetData): Tileset {
		if (tilesets.exists(data.name)) {
			return tilesets[data.name];
		} else {
			var set = Tileset.parse(data);
			tilesets[data.name] = set;
			return set;
		}
	}

}
