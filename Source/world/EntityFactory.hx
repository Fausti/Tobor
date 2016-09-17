package world;

import lime.system.System;
import world.entities.Object;

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
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_STABIL",
				
				subType:1,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_SW",
				
				subType:2,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_NE",
				
				subType:3,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_NW",
				
				subType:4,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_SE",
				
				subType:5,
			}),
			
			// Schwarze Mauer
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK",
				
				subType:6,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_SW",
				
				subType:7,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_NE",
				
				subType:8,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
				classPath:CORE + "Wall",
				editorSprite:"SPR_MAUER_BLACK_NW",
				
				subType:9,
			}),
			
			new EntityTemplate({
				name:"OBJ_MAUER",
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
				name:"OBJ_LEBEN",
				subType:0,
				editorSprite:"SPR_LEBEN",
				classPath:CORE + "LifeElixir",
			}),
			
			new EntityTemplate ({
				name:"OBJ_SAEURE_FLASCHE",
				subType:0,
				editorSprite:"SPR_SAEURE_FLASCHE",
				classPath:CORE + "AcidFlask",
			}),
			
			new EntityTemplate ({
				name:"OBJ_KNOBLAUCH",
				subType:0,
				editorSprite:"SPR_KNOBLAUCH",
				classPath:CORE + "Garlic",
			}),
			
			new EntityTemplate ({
				name:"OBJ_UHR",
				subType:0,
				editorSprite:"SPR_UHR",
				classPath:CORE + "Clock",
			}),
		
			new EntityTemplate ({
				name:"OBJ_GOLD",
				subType:0,
				editorSprite:"SPR_GOLD",
				classPath:CORE + "Gold",
			}),
			
			new EntityTemplate ({
				name:"OBJ_DIAMANT",
				subType:0,
				editorSprite:"SPR_DIAMANT_0",
				classPath:CORE + "Diamond",
			}),
			
			new EntityTemplate ({
				name:"OBJ_DIAMANT",
				subType:1,
				editorSprite:"SPR_DIAMANT_1",
				classPath:CORE + "Diamond",
			}),
			
			new EntityTemplate ({
				name:"OBJ_MAGNET",
				subType:0,
				editorSprite:"SPR_MAGNET_0",
				classPath:CORE + "Magnet",
			}),
			
			new EntityTemplate ({
				name:"OBJ_MAGNET",
				subType:1,
				editorSprite:"SPR_MAGNET_1",
				classPath:CORE + "Magnet",
			}),
			
			new EntityTemplate ({
				name:"OBJ_TOTENKOPF",
				subType:0,
				editorSprite:"SPR_TOTENKOPF",
				classPath:CORE + "Skull",
			}),
			
			new EntityTemplate ({
				name:"OBJ_BANK",
				subType:0,
				editorSprite:"SPR_BANK",
				classPath:CORE + "Bank",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL",
				subType:0,
				editorSprite:"SPR_PFEIL_E",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL",
				subType:1,
				editorSprite:"SPR_PFEIL_N",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL",
				subType:2,
				editorSprite:"SPR_PFEIL_W",
				classPath:CORE + "Arrow",
			}),
			
			new EntityTemplate({
				name:"OBJ_PFEIL",
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
				name:"OBJ_TUER",
				subType:0,
				editorSprite:"SPR_TUER_MONO_0",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:1,
				editorSprite:"SPR_TUER_MONO_1",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:2,
				editorSprite:"SPR_TUER_MONO_2",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:3,
				editorSprite:"SPR_TUER_MONO_3",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:4,
				editorSprite:"SPR_TUER_MONO_4",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:5,
				editorSprite:"SPR_TUER_MONO_5",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:6,
				editorSprite:"SPR_TUER_MONO_6",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:7,
				editorSprite:"SPR_TUER_MONO_7",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:8,
				editorSprite:"SPR_TUER_MONO_8",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:9,
				editorSprite:"SPR_TUER_MONO_9",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:10,
				editorSprite:"SPR_TUER_MONO_10",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:11,
				editorSprite:"SPR_TUER_MONO_11",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:12,
				editorSprite:"SPR_TUER_MONO_12",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:13,
				editorSprite:"SPR_TUER_MONO_13",
				classPath:CORE + "Door",
			}),
			
			new EntityTemplate({
				name:"OBJ_TUER",
				subType:14,
				editorSprite:"SPR_TUER_MONO_14",
				classPath:CORE + "Door",
			}),
			
			// Schlüssel

			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:0,
				editorSprite:"SPR_SCHLUESSEL_MONO_0",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:1,
				editorSprite:"SPR_SCHLUESSEL_MONO_1",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:2,
				editorSprite:"SPR_SCHLUESSEL_MONO_2",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:3,
				editorSprite:"SPR_SCHLUESSEL_MONO_3",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:4,
				editorSprite:"SPR_SCHLUESSEL_MONO_4",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:5,
				editorSprite:"SPR_SCHLUESSEL_MONO_5",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:6,
				editorSprite:"SPR_SCHLUESSEL_MONO_6",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:7,
				editorSprite:"SPR_SCHLUESSEL_MONO_7",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:8,
				editorSprite:"SPR_SCHLUESSEL_MONO_8",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:9,
				editorSprite:"SPR_SCHLUESSEL_MONO_9",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:10,
				editorSprite:"SPR_SCHLUESSEL_MONO_10",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:11,
				editorSprite:"SPR_SCHLUESSEL_MONO_11",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:12,
				editorSprite:"SPR_SCHLUESSEL_MONO_12",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:13,
				editorSprite:"SPR_SCHLUESSEL_MONO_13",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLUESSEL",
				subType:14,
				editorSprite:"SPR_SCHLUESSEL_MONO_14",
				classPath:CORE + "Key",
			}),
			
			new EntityTemplate ({
				name:"OBJ_PLATIN",
				subType:0,
				editorSprite:"SPR_PLATIN",
				classPath:CORE + "Platin",
			}),
			
			new EntityTemplate ({
				name:"OBJ_AUSRUFEZEICHEN",
				subType:0,
				editorSprite:"SPR_AUSRUFEZEICHEN",
				classPath:CORE + "InfoSign",
			}),
			
			new EntityTemplate ({
				name:"OBJ_NEST",
				subType:0,
				editorSprite:"SPR_NEST_0",
				classPath:CORE + "Nest",
			}),
			
			new EntityTemplate ({
				name:"OBJ_ROBOT",
				subType:0,
				editorSprite:"SPR_ROBOT_EDITOR",
				classPath:CORE + "Robot",
			}),
			
			// Munition
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:0,
				editorSprite:"SPR_MUNITION_0",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:1,
				editorSprite:"SPR_MUNITION_1",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:2,
				editorSprite:"SPR_MUNITION_2",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:3,
				editorSprite:"SPR_MUNITION_3",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:4,
				editorSprite:"SPR_MUNITION_4",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_MUNITION",
				subType:5,
				editorSprite:"SPR_MUNITION_5",
				classPath:CORE + "Bullet",
			}),
			
			new EntityTemplate({
				name:"OBJ_SCHLEUDER",
				subType:0,
				editorSprite:"SPR_SCHLEUDER",
				classPath:CORE + "Sling",
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
	
	public static function createFromID(id:String, subType:Int):Object {
		var e = findID(id, subType);
		
		// Fallback für Objekte mit dynamischer ID!
		if (e == -1) e = findID(id, 0);
		
		return create(e);
	}
	
	public static function create(index:Int):Object {
		if (index == -1) {
			trace("ENTITY FACTORY ERROR: Id is -1!");
			// System.exit(1);
			
			return null;
		}
		
		var entity:Object = null;
		
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

	public static function getfromKey(key:String):EntityTemplate {
		var id:Int = findKey(key);
		
		if (id < 0) {
			return null;
		}
		
		return table[id];
	}
	
	public static function getfromKeyID(key:String, type:Int):EntityTemplate {
		var id:Int = findID(key, type);
		
		if (id < 0) {
			return null;
		}
		
		return table[id];
	}
	
	public static function findKey(key:String):Int {
		var id:Int = 0;
		
		for (t in table) {
			if (t.name == key && t.subType == 0) return id;
			id++;
		}
		
		return -1;
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
	
	public static function findIDFromObject(o:Object):Int {
		var id:Int = 0;
		var path = Type.getClassName(Type.getClass(o));
		
		for (t in table) {
			if (t.classPath == path && t.subType == o.type) return id;
			id++;
		}
		
		return -1;
	}
}