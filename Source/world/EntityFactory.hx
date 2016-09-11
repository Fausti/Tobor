package world;

import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */

class EntityFactory {
	public static var table:Array<EntityTemplate>;
	
	public static function init():Bool {
		var CORE:String = "world.entities.core.";
		
		table = [
			new EntityTemplate({
				name:"OBJ_CHARLIE",
				classPath:CORE + "Charlie",
				editorSprite:"SPR_CHARLIE",
			}),
		
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER",
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_STABIL",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER_STABIL",
				
				subType:1,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_SW",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER_SW",
				
				subType:2,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_NE",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER_NE",
				
				subType:3,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_NW",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER_NW",
				
				subType:4,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_SE",
				classPath:CORE + "Mauer",
				editorSprite:"SPR_MAUER_SE",
				
				subType:5,
			}),
			
			new EntityTemplate ({
				name:"OBJ_ISOLATOR",
				subType:0,
				editorSprite:"SPR_ISOLATOR",
				classPath:CORE + "Isolator",
			}),
			new EntityTemplate ({
				name:"OBJ_ELEKTROZAUN",
				subType:0,
				editorSprite:"SPR_ELEKTROZAUN",
				classPath:CORE + "Elektrozaun",
			}),
		
			new EntityTemplate ({
				name:"OBJ_MAUER_AUFLOESEN",
				subType:0,
				editorSprite:"SPR_MAUER_AUFLOESEN_1",
				classPath:CORE + "MauerZersetzen",
			}),
		
			new EntityTemplate ({
				name:"OBJ_GOLD",
				subType:0,
				editorSprite:"SPR_GOLD",
				classPath:CORE + "Gold",
			}),
		];
		
		var isOK:Bool = true;
		for (t in table) {
			if (t.error != null) {
				isOK = false;
				trace(t.error);
			}
		}
		
		return isOK;
	}
	
	public static function createFromID(id:String, subType:Int):Entity {
		return create(findID(id, subType));
	}
	
	public static function create(index:Int):Entity {
		var entity:Entity = null;
		
		var _className = table[index].classPath;
		if (_className != null) {
			var _class = Type.resolveClass(_className);
			if (_class != null) {
				entity = Type.createInstance(_class, [table[index].subType]);
			} else {
				trace("Couldn't create instance of " + _className);
			}
		}
		
		return entity;
	}
	
	public static function findID(key:String, ?type):Int {
		var id:Int = 0;
		
		for (t in table) {
			if (t.name == key && t.subType == type) return id;
			id++;
		}
		
		return -1;
	}
	
	public static function findIDFromObject(o:Entity):Int {
		var id:Int = 0;
		var path = Type.getClassName(Type.getClass(o));
		
		for (t in table) {
			if (t.classPath == path && t.subType == o.type) return id;
			id++;
		}
		
		return -1;
	}
}