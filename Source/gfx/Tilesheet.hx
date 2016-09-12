package gfx;

import lime.Assets;
import lime.graphics.Image;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Tilesheet {
	public var width:Int;
	public var height:Int;
	
	var tileset:Array<Rectangle> = [];
	var registry:Map<String, Rectangle>;
	
	public function new(sourceTexture:Texture) {
		this.width = sourceTexture.width;
		this.height = sourceTexture.height;
		
		generateRects();
		
		registry = new Map<String, Rectangle>();
	}
	
	function generateRects() {
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
	
	public function register(key:String, indexes:Array<Array<Int>>) {
		var count:Int = 0;
		
		for (index in indexes) {
			registry.set(key.toUpperCase() + "_" + count, tile(index[0], index[1]));
			count++;
		}
	}
	
	public function find(key:String):Rectangle {
		var r = registry.get(key.toUpperCase());
		
		if (r == null) {
			// kleiner Shortcut für Einzelbilder
			
			r = registry.get(key.toUpperCase() + "_0");
		}
		
		if (r == null) {
			trace("TILESET ERROR: Konnte Grafik '" + key + "' nicht finden!");
		}
		
		return r;
	}
}