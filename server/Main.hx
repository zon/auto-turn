package server;

import haxe.Timer;
import common.Config;
import server.Dispatcher;

class Main {
	public var dispatcher: Dispatcher;

	var previous: Float;
	var running = true;

	public function new() {
		dispatcher = new Dispatcher();
	}

	public function start() {
		previous = Timer.stamp();

		dispatcher.start();
		
		while(running) {
			var now = Timer.stamp();
			var dt = now - previous;
			previous = now;
			update(dt);
			now = Timer.stamp();
			var delay = Config.tick - (now - previous);
			if (delay > 0) {
				Sys.sleep(delay);
			}
		}
		
		stop();
	}

	public function stop() {
		dispatcher.stop();
		running = false;
	}

	function update(dt) {
		dispatcher.update(dt);
	}

	static function main() {
		var app = new Main();
		app.start();
	}

}
