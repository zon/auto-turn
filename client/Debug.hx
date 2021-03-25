package client;

import h2d.Graphics;
import h2d.Object;

class Debug extends Object {
	var graphics: Graphics;

	static var instance: Debug;

	public function new(?parent: Object) {
		super(parent);
		graphics = new Graphics(this);
	}

	public static function setup(parent: Object) {
		instance = new Debug(parent);
	}

	public static function clear() {
		instance.graphics.clear();
	}

	public static function drawCircle(cx, cy, radius, nsegments = 0) {
		instance.graphics.drawCircle(cx, cy, radius, nsegments);
	}

	public static function lineStyle(size = 0.0, color = 0, alpha = 1.0) {
		instance.graphics.lineStyle(size, color, alpha);
	}

	public static function lineTo(x, y) {
		instance.graphics.lineTo(x, y);
	}

	public static function moveTo(x, y) {
		instance.graphics.moveTo(x, y);
	}

	public static function setColor(color, alpha = 1.0) {
		instance.graphics.setColor(color, alpha);
	}

}
