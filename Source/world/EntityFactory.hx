package world;

import lime.system.System;
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
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER",
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_STABIL",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_STABIL",
				
				subType:1,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_SW",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_SW",
				
				subType:2,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_NE",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_NE",
				
				subType:3,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_NW",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_NW",
				
				subType:4,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_SE",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_SE",
				
				subType:5,
			}),
			
			// Schwarze Mauer
			
			new EntityTemplate({
				name:"OBJ_MAUER_BLACK",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK",
				
				subType:6,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_BLACK_SW",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_SW",
				
				subType:7,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_BLACK_NE",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_NE",
				
				subType:8,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_BLACK_NW",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_NW",
				
				subType:9,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER_BLACK_SE",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_SE",
				
				subType:10,
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
				classPath:CORE + "WallDestroy",
			}),
		
			new EntityTemplate ({
				name:"OBJ_GOLD",
				subType:0,
				editorSprite:"SPR_GOLD",
				classPath:CORE + "Gold",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL_E",
				subType:0,
				editorSprite:"SPR_PFEIL_E",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL_N",
				subType:1,
				editorSprite:"SPR_PFEIL_N",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL_W",
				subType:2,
				editorSprite:"SPR_PFEIL_W",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL_S",
				subType:3,
				editorSprite:"SPR_PFEIL_S",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_AUSGANG",
				subType:0,
				editorSprite:"SPR_AUSGANG",
				classPath:CORE + "Exit",
			}),
			
			new EntityTemplate({
				name:"OBJ_BLOCKADE_ROBOTER",
				subType:0,
				editorSprite:"SPR_BLOCKADE_ROBOTER_AKTIV",
				classPath:CORE + "BarrierRobots",
			}),
		
			// Türen
			new EntityTemplate({
				name:"OBJ_TUER_0",
				subType:0,
				editorSprite:"SPR_TUER_0",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_1",
				subType:1,
				editorSprite:"SPR_TUER_1",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_2",
				subType:2,
				editorSprite:"SPR_TUER_2",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_3",
				subType:3,
				editorSprite:"SPR_TUER_3",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_4",
				subType:4,
				editorSprite:"SPR_TUER_4",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_5",
				subType:5,
				editorSprite:"SPR_TUER_5",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_6",
				subType:6,
				editorSprite:"SPR_TUER_6",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_7",
				subType:7,
				editorSprite:"SPR_TUER_7",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_8",
				subType:8,
				editorSprite:"SPR_TUER_8",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_9",
				subType:9,
				editorSprite:"SPR_TUER_9",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_10",
				subType:10,
				editorSprite:"SPR_TUER_10",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_11",
				subType:11,
				editorSprite:"SPR_TUER_11",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_12",
				subType:12,
				editorSprite:"SPR_TUER_12",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_13",
				subType:13,
				editorSprite:"SPR_TUER_13",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER_14",
				subType:14,
				editorSprite:"SPR_TUER_14",
				classPath:CORE + "Door",
			}),
			
			// Schlüssel

			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_0",
				subType:0,
				editorSprite:"SPR_SCHLUESSEL_0",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_1",
				subType:1,
				editorSprite:"SPR_SCHLUESSEL_1",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_2",
				subType:2,
				editorSprite:"SPR_SCHLUESSEL_2",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_3",
				subType:3,
				editorSprite:"SPR_SCHLUESSEL_3",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_4",
				subType:4,
				editorSprite:"SPR_SCHLUESSEL_4",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_5",
				subType:5,
				editorSprite:"SPR_SCHLUESSEL_5",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_6",
				subType:6,
				editorSprite:"SPR_SCHLUESSEL_6",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_7",
				subType:7,
				editorSprite:"SPR_SCHLUESSEL_7",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_8",
				subType:8,
				editorSprite:"SPR_SCHLUESSEL_8",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_9",
				subType:9,
				editorSprite:"SPR_SCHLUESSEL_9",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_10",
				subType:10,
				editorSprite:"SPR_SCHLUESSEL_10",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_11",
				subType:11,
				editorSprite:"SPR_SCHLUESSEL_11",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_12",
				subType:12,
				editorSprite:"SPR_SCHLUESSEL_12",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_13",
				subType:13,
				editorSprite:"SPR_SCHLUESSEL_13",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL_14",
				subType:14,
				editorSprite:"SPR_SCHLUESSEL_14",
				classPath:CORE + "Key",
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
		var e = findID(id, subType);
		
		// Fallback für Objekte mit dynamischer ID!
		if (e == -1) e = findID(id, 0);
		
		return create(e);
	}
	
	public static function create(index:Int):Entity {
		if (index == -1) {
			trace("ENTITY FACTORY ERROR: Id is -1!");
			System.exit(1);
		}
		
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
		
		// Fallback!
		
		id = 0;
		
		for (t in table) {
			if (t.name == key && t.subType == 0) return id;
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