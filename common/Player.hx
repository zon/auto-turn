package common;

import common.messages.PlayerMessage;

class Player {
	public var id: Int;

	public function new(id) {
		this.id = id;
	}

	public static function parse(msg: PlayerMessage) {
		return new Player(msg.id);
	}

}
