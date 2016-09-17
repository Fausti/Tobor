package world.entities;
import gfx.Gfx;
import screens.Screen;
import lime.math.Vector2;
import world.EntityTemplate;
import world.Room;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class Object extends Entity {
	public var isAlive:Bool = true;
	
	public var isStatic:Bool = true;
	public var changed:Bool = true;
	
	public var room:Room;
	
	// Shortcuts für das Spielerobjekt
	var player(get, null):Charlie;
	function get_player():Charlie {
		return room.world.player;
	}
	
	function isPlayer(e:Object):Bool {
		return Std.is(e, Charlie);
	}
	
	var gfx:gfx.IDrawable;
	
	public var type:Int;
	
	public function new(?type:Int = 0) {
		super();
		
		this.type = type;
	}
	
	public function reset() {
		
	}
	
	public function onCreate() {
		
	}
	
	public function canEnter(e:Object):Bool {
		return true;
	}
	
	public function onEnter(e:Object) {
		// trace(e);
	}
	
	// ---
	
	public function draw() {
		if (gfx == null) return;
		
		Gfx.drawTexture(x, y, 16, 12, gfx.getUV());
	}
	
	public function editor_draw() {
		draw();
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
	
	// Messaging
	
	public function onMessage(msg:Message) {
		trace(msg);
	}
	
	// Savegame Zeugs
	
	public function canSave():Bool {
		return true;
	}
	
	public function saveData():Map<String, Dynamic> {
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
	
	public function parseData(key:String, value:Dynamic) {
		if (value == null) return;
		
		switch(key) {
			case "type":
				type = value;
			case "x":
				gridX = value;
			case "y":
				gridY = value;
			case "id":
			default:
				Debug.error(this, "Couldn't parse key '" + key + "' with value '" + value + "'!");
		}
	}
	
	override public function get_ID():String {
		var id:Int = EntityFactory.findIDFromObject(this);
		var temp:EntityTemplate = EntityFactory.table[id];
		
		if (temp == null) return null;
		
		return temp.name;
	}
}
