package client.views;

import h2d.Tile;
import hxd.Res;
import client.views.View;

class ResMap {
	public var general: Tile;
	public var entity: SpriteFrames;

	var tiles: Array<Tile>;

	public function new() {
		Res.initEmbed();
		this.general = Res.load('general.png').toTile();
		this.tiles = this.general.gridFlatten(View.unit);

		entity = new SpriteFrames('entity');
	}

	public function getTile(index) {
		return this.tiles[index];
	}

}
