package gfx;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Sprite implements IDrawable {

	var rect:Rectangle;
	
	public function new(r:Rectangle) {
		this.rect = r;
	}
	
	public function setRectangle(r:Rectangle) {
		this.rect = r;
	}
	
	/* INTERFACE gfx.IDrawable */
	
	public function update(deltaTime:Float):Void {
		
	}
	
	public function getUV():Rectangle {
		return rect;
	}
	
}