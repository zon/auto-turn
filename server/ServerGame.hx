package server;

import common.Calc;
import common.Game;
import common.Entity;

class ServerGame extends Game {

	var autoId: Int = 0;

	public function createEntity(x, y, playerId) {
		while (autoId <= 0 || getEntity(autoId) != null) {
			autoId = Calc.max(autoId + 1, 1);
		}
		var entity = new Entity(autoId, playerId);
		return addEntity(x, y, entity);
	}

	public function update(dt: Float) {
		for (entity in entities) {
			entity.update(dt);
		}
		for (entity in entities) {
			entity.movement.update(dt); 
		}
	}

}
