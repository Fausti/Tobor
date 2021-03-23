package ;
import haxe.Json;

/**
 * ...
 * @author Matthias Faust
 */
class GetText {
	static var db:TextDatabase;
	static var db_world:TextDatabase;
	
	public static function init() {
		db = new TextDatabase();
		db_world = new TextDatabase();
	}
	
	// Übersetzung zurückgeben
	public static function get(id:String):String {
		var txt = db_world.get(id, false);
		if (txt == null || txt == id) txt = db.get(id, true);
		
		if (txt == null) {
			txt = id;
		}
		
		return txt;
	}
	
	public static function getFromWorld(id:String):String {
		var txt = db_world.get(id);
		if (txt == null || txt == id) txt = db.get(id, false);
		
		if (txt == null) {
			txt = id;
		}
		
		return txt;
	}
	
	public static function loadJson(content:String) {
		if (content == null) return;
		
		var data = Json.parse(content);
		
		for (id in Reflect.fields(data)) {
			var de = Reflect.field(data, id);
			if (de != null) {
				var text = Reflect.field(de, "de");
				
				db.set(id, text, false);
			}
		}
	}
	
	public static function loadJsonForWorld(content:String) {
		if (content == null) return;
		
		var data = Json.parse(content);
		
		var regNotice:EReg = ~/^TXT_NOTICE_ROOM_(\d\d\d)_NR_(\d)$/i;
		var regNpc:EReg = ~/^TXT_NPC_ROOM_(\d\d\d)_NR_(\d)$/i;
		
		for (id in Reflect.fields(data)) {
			var newID:String = id;
			var de = Reflect.field(data, id);
			
			newID = regNotice.replace(newID, "TXT_ROOM_$1_NOTICE_NR_$2");
			newID = regNpc.replace(newID, "TXT_ROOM_$1_NPC_NR_$2");
			
			if (de != null) {
				var text:String = Reflect.field(de, "de");
				
				if (text != null) text.replaceAll("    ", "____");
				db_world.set(newID, text, false);
			}
		}
	}
	
	public static function load(content:String) {
		var lines:Array<String> = content.split("\n");
		
		var id:String = null;
		var text:String = null;
		
		for (line in lines) {
			line = StringTools.trim(line);
			
			if (line.indexOf("[_") == 0) {
				if (id != null) {
					if (text == null) text = id;
					db.set(id, StringTools2.rtrimLF(text), false);
					
					id = null;
					text = null;
				}
				
				id = line.substr(2, line.length - 4);
			} else {
				if (text == null) {
					text = line;
				} else {
					text = text + "\n" + line;
				}
			}
		}
		
		if (id != null) {
			if (text == null) text = id;
			db.set(id, StringTools2.rtrimLF(text), false);
			
			id = null;
			text = null;
		}
	}
	
	public static function loadForWorld(content:String) {
		var lines:Array<String> = content.split("\n");
		
		var id:String = null;
		var text:String = null;
		
		for (line in lines) {
			line = line.replaceAll("    ", "____");
			// line = StringTools.trim(line);
			
			if (line.indexOf("[_") == 0) {
				if (id != null) {
					if (text == null) text = id;
					
					text = StringTools2.rtrimLF(text);
					db_world.set(id, text, false);
					
					id = null;
					text = null;
				}
				
				id = line.substr(2, line.length - 4);
			} else {
				if (text == null) {
					text = line;
				} else {
					text = text + "\n" + line;
				}
			}
		}
		
		if (id != null) {
			if (text == null) text = id;
					
					text = StringTools2.rtrimLF(text);
					db_world.set(id, text, false);
					
					id = null;
					text = null;
		}
	}
	
	public static function save():String {
		var out:String = db.save();
		
		return out;
	}
	
	public static function saveForWorld():String {
		var out:String = db_world.save();
		
		return out;
	}
	
	public static function saveMissing():String {
		var out:String = db.save(true);
		
		return out;
	}
	
	public static function saveForWorldMissing():String {
		var out:String = db_world.save(true);
		
		return out;
	}
}

class TextDatabase {
	var dict:Map<String, String>;
	
	public function new() {
		clear();
	}
	
	public function clear() {
		dict = new Map();
	}
	
	public function sortKeys():Array<String> {
		var keys = [];
		
		for (key in dict.keys()) {
			keys.push(key);
		}
		
		keys.sort(function(a:String, b:String):Int
		{
			a = a.toLowerCase();
			b = b.toLowerCase();
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});
		
		return keys;
	}
	
	public function get(id:String, ?missing:Bool = true):String {
		if (!dict.exists(id)) {
			if (missing) dict.set(id, id);
			return id;
		}
		
		return dict.get(id);
	}
	
	public function set(id:String, txt:String, missing:Bool) {
		if (id == null || txt == null) return;
		
		if (id == txt) {
			if (!missing) return;
		}

		if (dict.exists(id)) {
			if (dict.get(id) == txt) return;
		}
		
		// trace("adding: " + id + " -> " + txt);
		dict.set(id, txt);
	}
	
	public function save(?missing:Bool = false) {
		var keys = sortKeys();
		
		var out:StringBuf = new StringBuf();
		
		for (id in keys) {
			var text:String = dict.get(id);
			
			if (missing) {
				if (id != text) continue;
			} else {
				// if (id == text) continue;
			}
			
			if (out.length != 0) out.add("\n");
			
			out.add("[_" + id + "_]\n");
			out.add(text);
			out.add("\n");
		}
		
		return out.toString();
	}
}