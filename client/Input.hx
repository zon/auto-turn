package client;

import hxd.Window;
import hxd.Event;
import h2d.Scene;
import client.Dispatcher;
import client.views.View;
import common.Player;

class Input {
	var scene: Scene;
	var dispatcher: Dispatcher;

	public function new(scene, dispatcher) {
		this.scene = scene;
		this.dispatcher = dispatcher;

		Window.getInstance().addEventTarget(onEvent);
	}

	public function onEvent(event: Event) {
		if (event.kind != ERelease) return;
		var x = View.toGrid(scene.mouseX);
		var y = View.toGrid(scene.mouseY);
		trace('Move command $x, $y');
		dispatcher.sendMove(x, y);
	}

}
