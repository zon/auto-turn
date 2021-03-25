package client.views;

typedef SpriteData = {
	var frames: Array<FrameData>;
	var meta: SpriteMetaData;
}

typedef FrameData = {
	var frame: FrameRect;
	var sourceSize: FrameSize;
}

typedef FrameRect = {
	var x: Int;
	var y: Int;
	var w: Int;
	var h: Int;
}

typedef FrameSize = {
	var w: Int;
	var h: Int;
}

typedef SpriteMetaData = {
	var image: String;
	var format: String;
	var frameTags: Array<FrameTag>;
}

typedef FrameTag = {
	var name: String;
	var from: Int;
	var to: Int;
	var direction: String;
}
