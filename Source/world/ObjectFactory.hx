package world;
import world.entities.Entity;
import world.entities.std.*;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectFactory {
	public var length(default, null):Int = 0;
	
	private var list:Map<String, ObjectTemplate> = new Map<String, ObjectTemplate>();
	
	public function new() {
		// OBJECT_NAME # OBJECT_TYPE
		// e.g. OBJ_KEY#2
		
		register("OBJ_CHARLIE", 	Charlie, 	Gfx.getSprite(16, 0));
		
		register("OBJ_ROBOT",		Robot, 		Gfx.getSprite(0, 120));
		
		register("OBJ_ISOLATOR", 	Isolator, 	Gfx.getSprite(240, 0));
		register("OBJ_ELECTRIC_FENCE", ElectricFence, Gfx.getSprite(64, 12));
		
		register("OBJ_SKULL", 		Skull, 		Gfx.getSprite(80, 12));
		
		register("OBJ_WALL", 		Wall, 		Gfx.getSprite(160, 0), 				{type: 0});
		register("OBJ_WALL_NE", 	Wall, 		Gfx.getSprite(160 + 16 * 1, 0), 	{type: 1});
		register("OBJ_WALL_SW", 	Wall, 		Gfx.getSprite(160 + 16 * 2, 0), 	{type: 2});
		register("OBJ_WALL_SE", 	Wall, 		Gfx.getSprite(160 + 16 * 3, 0), 	{type: 3});
		register("OBJ_WALL_NW", 	Wall, 		Gfx.getSprite(160 + 16 * 4, 0), 	{type: 4});
		
		register("OBJ_WALL_BLACK", 		Wall, 		Gfx.getSprite(48, 132),				{type: 5});
		register("OBJ_WALL_BLACK_NE", 	Wall, 		Gfx.getSprite(48 + 16 * 1, 132),	{type: 6});
		register("OBJ_WALL_BLACK_SW", 	Wall, 		Gfx.getSprite(48 + 16 * 2, 132),	{type: 7});
		register("OBJ_WALL_BLACK_SE", 	Wall, 		Gfx.getSprite(48 + 16 * 3, 132),	{type: 8});
		register("OBJ_WALL_BLACK_NW", 	Wall, 		Gfx.getSprite(48 + 16 * 4, 132),	{type: 9});
		
		register("OBJ_WALL_HARD", 	Wall, 		Gfx.getSprite(160, 12), 	{type: 10});
		
		register("OBJ_ROOM_EXIT", 	Exit, 		Gfx.getSprite(0, 12));
		
		register("OBJ_BANK",		Bank,		Gfx.getSprite(48, 12));
		register("OBJ_GOLD",		Gold, 		Gfx.getSprite(96, 12));
		
		register("OBJ_PLATIN", Platin, Gfx.getSprite(128, 12));
		register("OBJ_QUESTION_MARK", QuestionMark, Gfx.getSprite(144, 12));
		
		register("OBJ_CLOCK", Clock, Gfx.getSprite(176, 12));
		register("OBJ_EXCLAMATION_MARK", ExclamationMark, Gfx.getSprite(192, 12));
		
		register("OBJ_NOTICE", Notice, Gfx.getSprite(208, 12));
		
		register("OBJ_MAGNET#0", Magnet, Gfx.getSprite(224, 12), {type: 0});
		register("OBJ_MAGNET#1", Magnet, Gfx.getSprite(240, 12), {type: 1});
		
		for (i in 0 ... 6) {
			register("OBJ_MUNITION#" + Std.string(i), Munition, Gfx.getSprite(144 + i * 16, 60), {type: i});
		}
		
		for (i in 0 ... 15) {
			register("OBJ_DOOR#" + Std.string(i), Door, Gfx.getSprite(i * 16, 36), {type: i});
		}
		
		for (i in 0 ... 15) {
			register("OBJ_KEY#" + Std.string(i), Key, Gfx.getSprite(i * 16, 48), {type: i});
		}
		
		register("OBJ_EXPLOSION", 	Explosion, 	Gfx.getSprite(64, 0));
		
		register("OBJ_BARRIER", 	Barrier, 		Gfx.getSprite(240, 96));
		
		register("OBJ_ELEXIR",		Elexir,			Gfx.getSprite(224, 24));
		
		register("OBJ_BRIDGE_NS",		Bridge,			Gfx.getSprite(176,156), {type: 0});
		register("OBJ_BRIDGE_WE",		Bridge,			Gfx.getSprite(192,156), {type: 1});
		
	}
	
	public function register(id:String, c:Dynamic, spr:Sprite, ?d:Dynamic = null) {
		var _class:Class<Entity> = null;
		
		if (d == null) d = {};
		
		if (Std.is(c, String)) {
			_class = cast Type.resolveClass(c);
			
			if (_class == null) {
				_class = cast Type.resolveClass("world.entities.std." + c);
			}
		} else {
			_class = c;
		}
		
		list.set(id, new ObjectTemplate(id, length, _class, d, spr));
		length++;
	}
	
	public function get(index:Int):ObjectTemplate {
		var oe:ObjectTemplate = null;
		
		for (key in list.keys()) {
			oe = list.get(key);
			if (oe.index == index) return oe;
		}
		
		return null;
	}
	
	public function findFromID(id:String):ObjectTemplate {
		for (key in list.keys()) {
			var oe:ObjectTemplate = list.get(key);
			
			if (oe.name == id) return oe;
		}
		
		return null;
	}
	
	public function findFromObject(o:Dynamic, ?checkForType:Bool = true):ObjectTemplate {
		for (key in list.keys()) {
			var oe:ObjectTemplate = list.get(key);
			
			if (oe.classPath == Type.getClass(o)) {
				if (checkForType) {
					if (Reflect.hasField(oe.data, "type")) { 
						if (oe.data.type == cast(o, Entity).type) return oe;
					} else {
						return oe;
					}
				} else {
					return oe;
				}
			}
		}
		
		trace("Template not found for: " + Type.getClass(o));
		return null;
	}
	
	public function create(id:Dynamic):Entity {
		var oe:ObjectTemplate;
		
		if (Std.is(id, String)) {
			oe = list.get(id);
		} else {
			oe = get(cast id);
		}
		
		var e:Entity = null;
		
		if (oe != null) {
			e = oe.create();
		}
		
		return e;
	}
}

class ObjectTemplate {
	public var index:Int = -1;
	public var name:String;
	public var classPath:Class<Entity>;
	public var data:Dynamic;
	public var spr:Sprite;
	
	public function new(id:String, index:Int, c:Class<Entity>, d:Dynamic, spr:Sprite) {
		this.name = id;
		this.index = index;
		this.classPath = c;
		this.data = d;
		this.spr = spr;
	}
	
	public function create():Entity {
		var e:Entity = Type.createInstance(classPath, []);
		
		if (e != null) {
			e.parseData(data);
		}
		
		return e;
	}
	
	function toString() {
		return Std.string(index) + "# " + Std.string(classPath);
	}
}