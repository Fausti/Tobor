package world.entities;
import gfx.Gfx;
import gfx.Sprite;
import lime.math.Rectangle;
import lime.math.Vector2;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class Entity {
	private var room:Room;
	
	private var boundingBox:Rectangle;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	private var sprites:Array<Sprite> = [];
	
	public function new() {
		boundingBox = new Rectangle(0, 0, 1, 1);
	}
	
	public function setRoom(r:Room) {
		room = r;
	}
	
	public function update_begin(deltaTime:Float) {
		update(deltaTime);
	}
	
	public function update_end(deltaTime:Float) {
		
	}
	
	public function update(deltaTime:Float) {
		for (spr in sprites) {
			spr.update(deltaTime);
		}
	}
	
	public function render() {
		for (spr in sprites) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr);
		}
	}
	
	public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
	
	public function setPosition(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
	
	inline function get_x():Float {
		return boundingBox.x;
	}
	
	inline function set_x(v:Float):Float {
		return boundingBox.x = v;
	}
	
	inline function get_y():Float {
		return boundingBox.y;
	}
	
	inline function set_y(v:Float):Float {
		return boundingBox.y = v;
	}
	
	private function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
}