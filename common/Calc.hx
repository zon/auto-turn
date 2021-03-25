package common;

import common.Vector;

class Calc {

	public static function min(a: Int, b: Int) {
		return a < b ? a : b;
	}

	public static function lerp(a: Float, b: Float, p: Float) {
		return a + (b - a) * p;
	}
	
	public static function invLerp(a: Float, b: Float, v: Float) {
		return (v - a) / (b - a);
	}

	public static function mag(x: Float, y: Float) {
		return Math.sqrt(magSqr(x, y));
	}

	public static function magSqr(x: Float, y: Float) {
		return x * x + y * y;
	}

	public static function normal(x: Float, y: Float): Vector {
		var m = mag(x, y);
		if (m != 0) {
			return { x: x / m, y: y / m };
		} else {
			return { x: 0, y: 0 };
		}
	}

}
