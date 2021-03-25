package client;

import common.Game;

class ClientGame extends Game {

	public function update(dt: Float) {
		for (entity in entities) {
			entity.update(dt);
		}
	}

}
