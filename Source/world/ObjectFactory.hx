package world;
import world.entities.Drift;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityItem;
import world.entities.Marker;
import world.entities.std.*;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectFactory {
	public var length(default, null):Int = 0;
	
	private var list:Map<String, ObjectTemplate> = new Map<String, ObjectTemplate>();
	
	public var listItems:Array<ObjectTemplate> = [];
	public var listFloors:Array<ObjectTemplate> = [];
	
	public function new() {
		// OBJECT_NAME # OBJECT_TYPE
		// e.g. OBJ_KEY#2
		
		register("OBJ_CHARLIE", 	Charlie, 	Gfx.getSprite(16, 0));
		register("OBJ_START_POSITION", StartPosition, Gfx.getSprite(128, 156));
		
		register("OBJ_ROBOT",		Robot, 		Gfx.getSprite(0, 120), null, Room.LAYER_LEVEL_0 + 1);
		register("OBJ_ANDROID_EGG", AndroidEgg, Gfx.getSprite(208, 216), null);
		register("OBJ_ANDROID",		Android, 	Gfx.getSprite(176, 120), null, Room.LAYER_LEVEL_0 + 1);
		register("OBJ_SHARK",		Shark, 		Gfx.getSprite(126, 120), null, Room.LAYER_LEVEL_0 + 1);
		
		register("OBJ_GROUND_NEST", GroundNest, Gfx.getSprite(240, 24));
		register("OBJ_WATCHER", Watcher, Gfx.getSprite(80, 60), null, Room.LAYER_OVERLAY);
		
		register("OBJ_ISOLATOR", 	Isolator, 	Gfx.getSprite(240, 0));
		register("OBJ_ISOLATOR_SOFT", 	SoftIsolator, 	Gfx.getSprite(128, 132));
		register("OBJ_ISOLATOR_WATER", WaterIsolator, Gfx.getSprite(112, 156)).allowInEditor(false);
		
		register("OBJ_ELECTRIC_FENCE", ElectricFence, Gfx.getSprite(64, 12), {type: 0});
		register("OBJ_ELECTRIC_FENCE_OFF", ElectricFence, Gfx.getSprite(96, 156), {type: 1});
		
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
		// register("OBJ_QUESTION_MARK", QuestionMark, Gfx.getSprite(144, 12));
		
		register("OBJ_CLOCK", Clock, Gfx.getSprite(176, 12))
			.setPoints(200);
		
		register("OBJ_NOTICE", Notice, Gfx.getSprite(208, 12));
		
		register("OBJ_MAGNET#0", Magnet, Gfx.getSprite(224, 12), {type: 0})
			.setPoints(500);
		register("OBJ_MAGNET#1", Magnet, Gfx.getSprite(240, 12), {type: 1})
			.setPoints(500);
		
		register("OBJ_TREE", Tree, Gfx.getSprite(80, 24))
			.setPoints(100);
		
		register("OBJ_CLONE", Clone, Gfx.getSprite(128, 60))
			.setPoints(100);
		
		register("OBJ_DIAMOND#0", Diamond, Gfx.getSprite(160, 24), {type: 0})
			.setPoints(1000);
		register("OBJ_DIAMOND#1", Diamond, Gfx.getSprite(176, 24), {type: 1})
			.setPoints(1000);
		
		register("OBJ_SLING", Sling, Gfx.getSprite(240, 60))
			.setPoints(1500);
		
		for (i in 0 ... 6) {
			register("OBJ_MUNITION#" + Std.string(i), Munition, Gfx.getSprite(144 + i * 16, 60), {type: i})
				.setPoints(100);
		}
		
		// Berge
		
		register("OBJ_MOUNTAIN_PATH", MountainPath, Gfx.getSprite(144, 264), null, Room.LAYER_FLOOR);
		
		for (i in 0 ... 4) {
			register("OBJ_MOUNTAIN_" + Std.string(i), Mountain, Gfx.getSprite(176 + i * 16, 264), {type: i}, Room.LAYER_FLOOR);
		}
		
		for (i in 0 ... 8) {
			register("OBJ_MOUNTAIN_" + Std.string(i + 4), Mountain, Gfx.getSprite(128 + i * 16, 288), {type: i + 4}, Room.LAYER_FLOOR);
		}
		
		for (i in 0 ... 8) {
			register("OBJ_MOUNTAIN_" + Std.string(i + 12), Mountain, Gfx.getSprite(128 + i * 16, 300), {type: i + 12}, Room.LAYER_FLOOR);
		}
		
		// Türen
		
		for (i in 0 ... 15) {
			register("OBJ_DOOR#" + Std.string(i), Door, Gfx.getSprite(i * 16, 36), {type: i});
		}
		
		for (i in 0 ... 15) {
			register("OBJ_KEY#" + Std.string(i), Key, Gfx.getSprite(i * 16, 48), {type: i})
				.setPoints(500);
		}
		
		register("OBJ_EXPLOSION", 	Explosion, 	Gfx.getSprite(64, 0)).allowInEditor(false);
		
		register("OBJ_BARRIER", 	Barrier, 		Gfx.getSprite(240, 96));
		
		register("OBJ_ELEXIR",		Elexir,			Gfx.getSprite(224, 24))
			.setPoints(100);
		
		register("OBJ_GARLIC",		Garlic,			Gfx.getSprite(192, 24))
			.setPoints(100);
		
		// register("OBJ_BRIDGE_NS",		Bridge,			Gfx.getSprite(176,156), {type: 0});
		// register("OBJ_BRIDGE_WE",		Bridge,			Gfx.getSprite(192,156), {type: 1});
		
		var ii:Int = 0;
		for (iy in 0 ... 2) {
			for (ix in 0 ... 3) {
				register("OBJ_GOAL_" + Std.string(ii), Goal, Gfx.getSprite(160 + ix * 16, 216 + iy * 12), {type: ii});
				ii++;
			}
		}
		
		register("OBJ_ROOF_0", Roof, Gfx.getSprite(0, 132), {type: 0}, Room.LAYER_ROOF);
		register("OBJ_ROOF_1", Roof, Gfx.getSprite(0, 144), {type: 1}, Room.LAYER_ROOF);
		register("OBJ_ROOF_2", Roof, Gfx.getSprite(16, 132), {type: 2}, Room.LAYER_ROOF);
		register("OBJ_ROOF_3", Roof, Gfx.getSprite(16, 144), {type: 3}, Room.LAYER_ROOF);
		register("OBJ_ROOF_4", Roof, Gfx.getSprite(32, 132), {type: 4}, Room.LAYER_ROOF);
		register("OBJ_ROOF_5", Roof, Gfx.getSprite(32, 144), {type: 5}, Room.LAYER_ROOF);
		register("OBJ_ROOF_6", Roof, Gfx.getSprite(48, 144), {type: 6}, Room.LAYER_ROOF);
		register("OBJ_ROOF_7", Roof, Gfx.getSprite(64, 144), {type: 7}, Room.LAYER_ROOF);
		register("OBJ_ROOF_8", Roof, Gfx.getSprite(80, 144), {type: 8}, Room.LAYER_ROOF);
		
		for (i in 0 ... 3) {
			register("OBJ_SHADOW#" + Std.string(i), Shadow, Gfx.getSprite(48 + (i * 16), 156), {type: i}, Room.LAYER_FLOOR);
		}
		
		for (i in 0 ... 5) {
			register("OBJ_SAND#" + Std.string(i), Sand, Gfx.getSprite(16 * i, 24), {type: i}, Room.LAYER_FLOOR);
		}
		
		for (i in 0 ... 4) {
			register("OBJ_TUNNEL#" + Std.string(i), Tunnel, Gfx.getSprite(192 + i * 16, 72), {type: i}, Room.LAYER_FLOOR);
		}
		
		register("OBJ_STAIRS_UP", Stairs, Gfx.getSprite(224, 108), {type: 0});
		register("OBJ_STAIRS_DOWN", Stairs, Gfx.getSprite(240, 108), {type: 1});
		
		register("OBJ_ACID", Acid, Gfx.getSprite(208, 24))
			.setPoints(200);
		
		register("OBJ_WALL_DISSOLVE", WallDissolve, Gfx.getSprite(64, 60));
		register("OBJ_WALL_SAND_DISSOLVE", SandWallDissolve, Gfx.getSprite(64 + 64, 168));
		
		register("OBJ_HARD_SAND_0", SandHard, Gfx.getSprite(208, 144), {type: 0}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_1", SandHard, Gfx.getSprite(208 + 16, 144), {type: 1}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_2", SandHard, Gfx.getSprite(208 + 32, 144), {type: 2}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_3", SandHard, Gfx.getSprite(208, 144 + 12), {type: 3}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_4", SandHard, Gfx.getSprite(208 + 16, 144 + 12), {type: 4}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_5", SandHard, Gfx.getSprite(208 + 32, 144 + 12), {type: 5}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_6", SandHard, Gfx.getSprite(208 + 16, 144 + 24), {type: 6}, Room.LAYER_FLOOR);
		register("OBJ_HARD_SAND_7", SandHard, Gfx.getSprite(208 + 32, 144 + 24), {type: 7}, Room.LAYER_FLOOR);
		
		register("OBJ_SAND_DECO_0", SandDeco, Gfx.getSprite(208, 132), {type: 0}, Room.LAYER_FLOOR);
		register("OBJ_SAND_DECO_1", SandDeco, Gfx.getSprite(208 + 16, 132), {type: 1}, Room.LAYER_FLOOR);
		register("OBJ_SAND_DECO_2", SandDeco, Gfx.getSprite(208 + 32, 132), {type: 2}, Room.LAYER_FLOOR);
		
		register("OBJ_SCORPION", Scorpion, Gfx.getSprite(176, 168), null, Room.LAYER_LEVEL_0 + 1);
		
		register("OBJ_KNIFE", Knife, Gfx.getSprite(48, 168));
		
		for (i in 0 ... 3) {
			register("OBJ_SAND_PLANT_" + Std.string(i), SandPlant, Gfx.getSprite(0 + 16 * i, 168), {type: i});
		}
		
		register("OBJ_SAND_WALL", 		Wall, 		Gfx.getSprite(32, 120), 				{type: 11});
		register("OBJ_SAND_WALL_NE", 	Wall, 		Gfx.getSprite(32 + 16 * 1, 120), 	{type: 12});
		register("OBJ_SAND_WALL_SW", 	Wall, 		Gfx.getSprite(32 + 16 * 2, 120), 	{type: 13});
		register("OBJ_SAND_WALL_SE", 	Wall, 		Gfx.getSprite(32 + 16 * 3, 120), 	{type: 14});
		register("OBJ_SAND_WALL_NW", 	Wall, 		Gfx.getSprite(32 + 16 * 4, 120), 	{type: 15});
		
		for (i in 0 ... 4) {
			register("OBJ_ARROW_" +Std.string(i), Arrow, Gfx.getSprite(96 + 16 * i, 24), {type: i});
		}
		
		register("OBJ_GRATE", Grate, Gfx.getSprite(240, 84));
		
		register("OBJ_EXCLAMATION_MARK", ExclamationMark, Gfx.getSprite(192, 12))
			.setPoints(1500);
		
		register("OBJ_OVERALL", Overall, Gfx.getSprite(176, 132))
			.setPoints(1500);
		
		for (i in 0 ... 5) {
			register("OBJ_BAGPACK#" + i, Bagpack, Gfx.getSprite(128 + i * 16, 144), {type: i});
		}
		
		register("OBJ_TELEPORT_START_0", TeleportStart, Gfx.getSprite(0, 312), {type: 0});
		register("OBJ_TELEPORT_START_1", TeleportStart, Gfx.getSprite(48, 312), {type: 1});
		
		register("OBJ_TELEPORT_END_0", TeleportEnd, Gfx.getSprite(16, 312), {type: 0});
		register("OBJ_TELEPORT_END_1", TeleportEnd, Gfx.getSprite(64, 312), {type: 1});
		
		// Water
		
		register("OBJ_FLIPPERS", Flippers, Gfx.getSprite(96, 144))
			.setPoints(3000);
		
		register("OBJ_WATER_SHALLOW", Water, Gfx.getSprite(0, 72), {type: 0}, Room.LAYER_FLOOR);
		register("OBJ_WATER_DEEP", Water, Gfx.getSprite(16, 72), {type: 1}, Room.LAYER_FLOOR);
			
		register("OBJ_WATER_NW", Water, Gfx.getSprite(80, 72), {type: 2}, Room.LAYER_FLOOR);
		register("OBJ_WATER_SW", Water, Gfx.getSprite(96, 72), {type: 3}, Room.LAYER_FLOOR);
		register("OBJ_WATER_NE", Water, Gfx.getSprite(112, 72), {type: 4}, Room.LAYER_FLOOR);
		register("OBJ_WATER_SE", Water, Gfx.getSprite(128, 72), {type: 5}, Room.LAYER_FLOOR);
			
		register("OBJ_WATER_DEADLY", WaterDeadly, Gfx.getSprite(48, 72), null, Room.LAYER_FLOOR);
		
		// Drift
		
		register("DRIFT_S", Drift, Gfx.getSprite(0, 300), {type: 0}, Room.LAYER_DRIFT);
		register("DRIFT_N", Drift, Gfx.getSprite(16, 300), {type: 1}, Room.LAYER_DRIFT);
		register("DRIFT_W", Drift, Gfx.getSprite(32, 300), {type: 2}, Room.LAYER_DRIFT);
		register("DRIFT_E", Drift, Gfx.getSprite(48, 300), {type: 3}, Room.LAYER_DRIFT);
		
		register("DRIFT_NW", Drift, Gfx.getSprite(64, 300), {type: 4}, Room.LAYER_DRIFT);
		register("DRIFT_NE", Drift, Gfx.getSprite(80, 300), {type: 5}, Room.LAYER_DRIFT);
		register("DRIFT_SW", Drift, Gfx.getSprite(96, 300), {type: 6}, Room.LAYER_DRIFT);
		register("DRIFT_SE", Drift, Gfx.getSprite(112, 300), {type: 7}, Room.LAYER_DRIFT);
		
		register("OBJ_BUCKET#0", Bucket, Gfx.getSprite(144, 156), {type: 0})
			.setPoints(1000);
		register("OBJ_BUCKET#1", Bucket, Gfx.getSprite(160, 156), {type: 1})
			.setPoints(1000);

		for (i in 0 ... 5) {
			register("OBJ_ICE_" + Std.string(i), Ice, Gfx.getSprite(64 + i * 16, 324), {type: i}, Room.LAYER_FLOOR);
		}
		
		register("OBJ_ICE_BLOCK", IceBlock, Gfx.getSprite(144, 324));
		
		register("OBJ_THERMOPLATE_0", ThermoPlate, Gfx.getSprite(160, 324), {type: 0}, Room.LAYER_FLOOR);
		register("OBJ_THERMOPLATE_1", ThermoPlate, Gfx.getSprite(176, 324), {type: 1}, Room.LAYER_FLOOR);
		register("OBJ_THERMOPLATE_2", ThermoPlate, Gfx.getSprite(192, 324), {type: 2}, Room.LAYER_FLOOR);
		
		for (i in 0 ... 7) {
			register("OBJ_WOOD_" + Std.string(i), Wood, Gfx.getSprite(0 + (i * 16), 252), {type: i}, Room.LAYER_FLOOR);
		}
		
		register("OBJ_WOOD_PATH", WoodPath, Gfx.getSprite(112, 252), null, Room.LAYER_FLOOR);
		
		for (i in 0 ... 2) {
			register("OBJ_GRASS_" + Std.string(i), Grass, Gfx.getSprite(128 + 16 * i, 252), {type: i}, Room.LAYER_FLOOR);
		}
		
		register("OBJ_SHOES", Shoes, Gfx.getSprite(112, 144))
			.setPoints(1500);
		
		register("OBJ_COMPASS", Compass, Gfx.getSprite(176, 252))
			.setPoints(1500);
			
		// Höhle
		
		for (i in 0 ... 13) {
			register("OBJ_CAVE_" + Std.string(i), Cave, Gfx.getSprite(32 + (i * 16), 180), {type: i}, Room.LAYER_FLOOR);
		}
		
		// Fels
		
		for (i in 0 ... 9) {
			register("OBJ_BEDROCK_" + Std.string(i), Bedrock, Gfx.getSprite(0 + (i * 16), 264), {type: i}, Room.LAYER_FLOOR);
		}
		
		register("OBJ_BEDROCK_9", Bedrock, Gfx.getSprite(240, 264), {type: 9}, Room.LAYER_FLOOR);
		
		// Pfade
		
		register("OBJ_BEDROCK_PATH", BedrockPath, Gfx.getSprite(240, 180), null, Room.LAYER_FLOOR);
		register("OBJ_PATH", Path, Gfx.getSprite(224, 120), null, Room.LAYER_FLOOR);
		
		// Electric Stuff
		register("MARKER_0", Marker, Gfx.getSprite(0, 348), {type:0}, Room.LAYER_MARKER);
		register("MARKER_1", Marker, Gfx.getSprite(16, 348), {type:1}, Room.LAYER_MARKER);
		register("MARKER_2", Marker, Gfx.getSprite(32, 348), {type:2}, Room.LAYER_MARKER);
		register("MARKER_3", Marker, Gfx.getSprite(48, 348), {type:3}, Room.LAYER_MARKER);
		register("MARKER_4", Marker, Gfx.getSprite(64, 348), {type:4}, Room.LAYER_MARKER);
		
		register("OBJ_ELECTRIC_DOOR_0", ElectricDoor, Gfx.getSprite(0, 336), {type: 0});
		register("OBJ_ELECTRIC_DOOR_1", ElectricDoor, Gfx.getSprite(16, 336), {type: 1});
		
		register("OBJ_ELECTRIC_FLOOR_PLATE_0", ElectricFloorPlate, Gfx.getSprite(32, 336), {type: 0}, Room.LAYER_FLOOR);
		register("OBJ_ELECTRIC_FLOOR_PLATE_1", ElectricFloorPlate, Gfx.getSprite(48, 336), {type: 1}, Room.LAYER_FLOOR);
		
		register("OBJ_ROBOT_FACTORY_0", RobotFactory, Gfx.getSprite(0, 324), {type: 0});
		register("OBJ_ROBOT_FACTORY_1", RobotFactory, Gfx.getSprite(16, 324), {type: 1});
		
		register("OBJ_TARGET", Target, Gfx.getSprite(64, 336));
		
		register("OBJ_MIRROR_0", Mirror, Gfx.getSprite(32, 324), {type: 0});
		register("OBJ_MIRROR_1", Mirror, Gfx.getSprite(48, 324), {type: 1});
		
		for (i in 0 ... 4) {
			register("OBJ_SHOOTER_" + Std.string(i), Shooter, Gfx.getSprite(80 + (i * 16), 336), {type: i}, Room.LAYER_OVERLAY);
		}
	}
	
	public function register(id:String, c:Dynamic, spr:Sprite, ?d:Dynamic = null, ?layer:Int = Room.LAYER_LEVEL_0):ObjectTemplate {
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
		
		var ot:ObjectTemplate = new ObjectTemplate(id, length, _class, d, spr, layer);
		
		list.set(id, ot);
		length++;

		// Objekte nach Typ filtern...
		var e = Type.createEmptyInstance(_class);
		if (e != null) {
			if (Std.is(e, EntityItem)) {
				listItems.push(ot);
			} else if (Std.is(e, EntityFloor)) {
				listFloors.push(ot);
			}
		}
		
		return ot;
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
	public var canBePlaced:Bool = true;
	
	public var index:Int = -1;
	public var name:String;
	public var classPath:Class<Entity>;
	public var data:Dynamic;
	public var spr:Sprite;
	
	public var points:Int;
	
	public var layer:Int;
	
	public var editorName:String;
	
	public function new(id:String, index:Int, c:Class<Entity>, d:Dynamic, spr:Sprite, ?layer:Int = Room.LAYER_LEVEL_0) {
		this.name = id;
		this.index = index;
		this.classPath = c;
		this.data = d;
		this.spr = spr;
		this.layer = layer;
		
		this.editorName = Text.get(id);
		
		var e = Type.createEmptyInstance(c);
		if (e != null) {
			if (Std.is(e, EntityItem)) {
				var temp:String = Text.get(id + "_DESC");
				temp = Text.get(id.split("#")[0] + "_PICKUP");
			}
		}
	}
	
	public function allowInEditor(v:Bool):ObjectTemplate {
		this.canBePlaced = v;
		return this;
	}
	
	public function setPoints(p:Int):ObjectTemplate {
		this.points = p;
		
		return this;
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
	
	public function isRoof():Bool {
		return layer == Room.LAYER_ROOF;
	}
	
	public function isFloor():Bool {
		return layer == Room.LAYER_FLOOR;
	}
}