package server;

import udprotean.server.UDProteanClientBehavior;
import udprotean.server.UDProteanServer;
import common.Config;
import server.ClientBehavior;

class Server {
	public var dispatcher: Dispatcher;
	public var peer: UDProteanServer;
	public var clients = new Map<Int, ClientBehavior>();

	var autoId: Int = 0;

	public function new(dispatcher) {
		this.dispatcher = dispatcher;
		peer = new UDProteanServer('0.0.0.0', Config.port, ClientBehavior);
		peer.onClientConnected(onConnected);
		peer.onClientDisconnected(onDisconnected);
	}

	public function start() {
		peer.start();
		trace('Listening on: '+ Config.port);
	}

	public function update() {
		peer.update();
	}

	public function stop() {
		peer.stop();
	}

	public function sendAll(message, sendNow = true) {
		for (client in clients) {
			client.send(message, sendNow);
		}
	}

	public function sendOthers(entityId, message, sendNow = true) {
		for (client in clients) {
			if (client.entity != null && client.entity.id == entityId) continue;
			client.send(message, sendNow);
		}
	}

	public function sendPlayer(playerId, message, sendNow = true) {
		for (client in clients) {
			if (client.id == playerId) {
				client.send(message, sendNow);
				return;
			}
		}
	}

	function onConnected(udpc: UDProteanClientBehavior) {
		while (autoId == 0 || clients.exists(autoId)) {
			autoId += 1;
		}
		trace('Connected: '+ autoId);
		var client: ClientBehavior = cast udpc;
		client.dispatcher = dispatcher;
		client.id = autoId;
		clients[autoId] = client;
	}

	function onDisconnected(udpc: UDProteanClientBehavior) {
		var client: ClientBehavior = cast udpc;
		trace('Disconnected: '+ client.id);
		clients.remove(client.id);
	}
	
}
