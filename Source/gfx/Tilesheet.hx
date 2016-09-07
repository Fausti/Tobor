package gfx;

import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Tilesheet {
	public var width:Int;
	public var height:Int;
	
	var tileset:Array<Rectangle> = [];
	
	public function new(sourceTexture:Texture) {
		this.width = sourceTexture.width;
		this.height = sourceTexture.height;
		
		generateRects();
	}
	
	function generateRects() {
		// var sizeW:Float = 16 / 256;
		// var sizeH:Float = 12 / 504;
		
		var sizeW:Float = 16 / width;
		var sizeH:Float = 12 / height;
		
		for (y in 0 ... Std.int(height / 12)) {
			for (x in 0 ... Std.int(width / 16)) {
				tileset.push(new Rectangle((x * 16) / width, (y * 12) / height, sizeW, sizeH));
			}
		}
	}
	
	public inline function tile(x:Int, y:Int):Rectangle {
		return tileset[y * 16 + x];
	}
	
	public inline function rect(x:Int, y:Int, w:Int, h:Int):Rectangle {
		return new Rectangle(x / width, y / height, w / width, h / height);
	}
}