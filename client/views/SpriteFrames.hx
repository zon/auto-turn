package client.views;

import haxe.DynamicAccess;
import haxe.ds.Vector;
import haxe.Json;
import hxd.Res;
import h2d.Tile;
import h2d.Anim;
import client.views.SpriteData;

class SpriteFrames {
	var data: SpriteData;
	var main: Tile;
	var tiles: Vector<Tile>;

	public function new(file: String) {
		var text = Res.load('$file.json').toText();
		data = Json.parse(text);
		main = Res.load(data.meta.image).toTile();

		var tiles = new Array<Tile>();
		for (frame in data.frames) {
			var f = frame.frame;
			var s = frame.sourceSize;
			var tile = main.sub(
				f.x + (f.w - s.w) / 2,
				f.y + (f.h - s.h) / 2,
				s.w,
				s.h
			);
			tiles.push(tile);
		}
		this.tiles = Vector.fromArrayCopy(tiles);
	}

	public function getTile(index) {
		return tiles[index];
	}

	public function getTileByTag(name, index = 0) {
		return getTag(name)[index];
	}

	public function getTag(name) {
		var frames = new Array<Tile>();
		for (tag in data.meta.frameTags) {
			if (tag.name == name) {
				for (i in tag.from...(tag.to + 1)) {
					frames.push(getTile(i));
				}
				break;
			}
		}
		return frames;
	}

	public function getAnim(name): Anim {
		var frames = getTag(name);
		if (frames.length > 0) {
			return new Anim(frames);
		}
		return null;
	}

}
