package world;
import world.entities.Entity;
import world.entities.std.*;

/**
 * ...
 * @author Matthias Faust
 */
class Objects {
	public var length(default, null):Int = 0;
	
	private var list:Map<String, ObjectsEntry> = new Map<String, ObjectsEntry>();
	
	public function new() {
		register("OBJ_CHARLIE", 	Charlie, 	Gfx.getSprite(16, 0));
		
		register("OBJ_ROBOT",		Robot, 		Gfx.getSprite(0, 120));
		
		register("OBJ_ISOLATOR", 	Isolator, 	Gfx.getSprite(240, 0));
		register("OBJ_ELECTRIC_FENCE", ElektrikFence, Gfx.getSprite(64, 12));
		
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
		
		register("OBJ_MAGNET_0", Magnet, Gfx.getSprite(224, 12), {type: 0});
		register("OBJ_MAGNET_1", Magnet, Gfx.getSprite(240, 12), {type: 1});
		
		for (i in 0 ... 6) {
			register("OBJ_MUNITION_" + Std.string(i), Munition, Gfx.getSprite(144 + i * 16, 60), {type: i});
		}
		
		for (i in 0 ... 15) {
			register("OBJ_DOOR_" + Std.string(i), Door, Gfx.getSprite(i * 16, 36), {type: i});
		}
		
		for (i in 0 ... 15) {
			register("OBJ_KEY_" + Std.string(i), Key, Gfx.getSprite(i * 16, 48), {type: i});
		}
		
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
		
		list.set(id, new ObjectsEntry(length, _class, d, spr));
		length++;
	}
	
	public function get(index:Int):ObjectsEntry {
		var oe:ObjectsEntry = null;
		
		for (key in list.keys()) {
			oe = list.get(key);
			if (oe.index == index) return oe;
		}
		
		return null;
	}
	
	public function create(id:Dynamic):Entity {
		var oe:ObjectsEntry;
		
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

private class ObjectsEntry {
	public var index:Int = -1;
	var _class:Class<Entity>;
	var data:Dynamic;
	public var spr:Sprite;
	
	public function new(index:Int, c:Class<Entity>, d:Dynamic, spr:Sprite) {
		this.index = index;
		this._class = c;
		this.data = d;
		this.spr = spr;
	}
	
	public function create():Entity {
		var e:Entity = Type.createInstance(_class, []);
		
		if (e != null) {
			e.parseData(data);
		}
		
		return e;
	}
}