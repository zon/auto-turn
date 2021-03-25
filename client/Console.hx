package client;

import haxe.Template;
import h2d.Object;
import h2d.Text;

class Console {
	public var lines = new Array<String>();
	public var history = new Array<String>();

	var body: Text;

	public static var instance: Console;

	public function new(?parent: Object) {
		var font = hxd.res.DefaultFont.get();
		body = new Text(font, parent);
		body.x = 16;
		body.y = 16;
		body.scale(2);
		instance = this;
	}

	public function update() {
		while (history.length > 10) {
			history.shift();
		}
		var a = history.join('\n');
		var b = lines.join('\n');
		body.text = '$a\n\n$b';
		lines = [];
	}

	public static function status(text: Dynamic) {
		instance.lines.push(text);
	}

	public static function log(text: Dynamic) {
		instance.history.push(text);
	}

}
