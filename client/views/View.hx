package client.views;

class View {
	public static final unit = 16;
	public static final pixel = 4;

	public static function toGrid(v: Float) {
		return Math.floor(v / unit / pixel);
	}

	public static function fromGrid(g: Int) {
		return (g + 0.5) * unit;
	}

}
