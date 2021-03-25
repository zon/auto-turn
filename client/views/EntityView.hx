package client.views;

import hxd.Timer;
import h2d.Object;
import h2d.Bitmap;
import common.Entity;
import common.Calc;
import client.views.View;

class EntityView extends Bitmap {
	public var entity: Entity;

	public function new(entity: Entity, res: ResMap, ?parent: Object) {
		this.entity = entity;
		super(res.getTile(2), parent);
	}

	public function update() {
		if (entity.isActing()) {
			var p = entity.actionCooldown / entity.movement.actionDuration;
			x = Calc.lerp(entity.x, entity.movement.px, p);
			y = Calc.lerp(entity.y, entity.movement.py, p);
		} else {
			x = entity.x;
			y = entity.y;
		}
		x *= View.unit;
		y *= View.unit;
	}

}
