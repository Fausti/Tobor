package world.entities;
import gfx.Gfx;
import screens.Screen;
import lime.math.Vector2;
import world.EntityTemplate;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class Entity {
	public static inline var WIDTH:Int = 16;
	public static inline var HEIGHT:Int = 12;
	
	private var classPath:String;
	
	public var isAlive:Bool = true;
	
	public var isStatic:Bool = true;
	public var changed:Bool = true;
	
	var position:Vector2;
	
	public var room:Room;
	
	var gfx:gfx.IDrawable;
	
	public var type:Int;
	
	public function new(?type:Int = 0) {
		classPath = Type.getClassName(Type.getClass(this));
		
		this.type = type;
		
		position = new Vector2();
	}
	
	// Bildschirmposition
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	function get_x():Float {
		return position.x;
	}
	
	function set_x(v:Float):Float {
		position.x = v;
		
		return v;
	}
	
	function get_y():Float {
		return position.y;
	}
	
	function set_y(v:Float):Float {
		position.y = v;
		
		return v;
	}
	
	// Gridposition
	
	public var gridX(get, set):Int;
	public var gridY(get, set):Int;
	
	inline function get_gridX():Int {
		return Math.round(position.x / 16);
	}
	
	function set_gridX(v:Int):Int {
		position.x = v * WIDTH;
		
		return v * WIDTH;
	}
	
	inline function get_gridY():Int {
		return Math.round(position.y / HEIGHT);
	}
	
	function set_gridY(v:Int):Int {
		position.y = v * HEIGHT;
		
		return v * HEIGHT;
	}
	
	public function onCreate() {
		
	}
	
	public function canEnter(e:Entity):Bool {
		return true;
	}
	
	public function onEnter(e:Entity) {
		// trace(e);
	}
	
	// ---
	
	public function draw() {
		if (gfx == null) return;
		
		Gfx.drawTexture(x, y, 16, 12, gfx.getUV());
	}
	
	public function update(deltaTime:Float) {
		if (gfx != null) gfx.update(deltaTime);
		
		changed = false;
	}
	
	public function die() {
		
	}
	
	public function destroy() {
		room.remove(this);
	}
	
	public function save():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var id:Int = EntityFactory.findIDFromObject(this);
		var def:EntityTemplate = EntityFactory.table[id];
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("x", gridX);
			data.set("y", gridY);
		} else {
			return null;
		}
		
		return data;
	}
	
	public function toString():String {
		var id:Int = EntityFactory.findIDFromObject(this);
		// trace(id);
		
		var temp:EntityTemplate = EntityFactory.table[id];
		// trace(temp);
		
		var s = new StringBuf();
		s.add("[ ");
		s.add(id + ", ");
		s.add(getClassPath() + ", ");
		s.add(temp.classPath + ", ");
		s.add(temp.name + ", ");
		s.add(type + ", ");
		s.add(gridX + ", ");
		s.add(gridY);
		s.add(" ]");
		
		return s.toString();
	}
	
	public function getClassPath():String {
		return classPath;
	}
	
	public function canSave():Bool {
		return true;
	}
}