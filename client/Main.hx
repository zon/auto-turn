package client;

import hxd.App;
import client.Dispatcher;

class Main extends App {
	var dispatcher: Dispatcher;

	override function init() {
		dispatcher = new Dispatcher(this);
		dispatcher.init();
	}

	override function update(dt: Float) {
		dispatcher.update(dt);
	}

	override function dispose() {
		dispatcher.dispose();
		super.dispose();
	}

	static function main() {
		new Main();
	}

}
