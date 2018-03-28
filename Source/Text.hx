package;

import tjson.TJSON;
/**
 * ...
 * @author Matthias Faust
 */
class Text {
	static var db:TextDatabase;
	static var db_world:TextDatabase;
	
	public static function init() {
		db = new TextDatabase();
		db_world = new TextDatabase();
	}
	
	public static function get(key:String):String {
		var s:String = db.get(key);
		
		if (s == null) {
			db.set(key, key);
			s = key;
		}
		
		return s;
	}
	
	public static function getFromWorld(key:String):String {
		var s:String = db_world.get(key);
		
		if (s == null) {
			s = db.get(key);
			
			if (s == null) {
				db_world.set(key, key);
				s = key;
			}
		}
		
		return s;
	}
	
	public static function load(content:String) {
		if (content == null) {
			return;
		}
		
		var data = TJSON.parse(content);
		
		for (key in Reflect.fields(data)) {
			var data2 = Reflect.field(data, key);
			for (lang in Reflect.fields(data2)) {
				db.set(key, Reflect.field(data2, lang), lang);
			}
		}
	}
	
	public static function loadForWorld(content:String) {
		if (content == null) {
			return;
		}
		
		var data = TJSON.parse(content);
		
		for (key in Reflect.fields(data)) {
			var data2 = Reflect.field(data, key);
			for (lang in Reflect.fields(data2)) {
				db_world.set(key, Reflect.field(data2, lang), lang);
			}
		}
	}
	
	public static function save():String {
		var data:Map<String, Dynamic> = db.save();
		
		return TJSON.encode(data, 'fancy');
	}
	
	public static function saveForWorld():String {
		var data:Map<String, Dynamic> = db_world.save();
		
		return TJSON.encode(data, 'fancy');
	}
	
	public static function saveMissing():String {
		var data:Map<String, Dynamic> = db.saveMissing();
		
		return TJSON.encode(data, 'fancy');
	}
	
	public static function saveForWorldMissing():String {
		var data:Map<String, Dynamic> = db_world.saveMissing();
		
		return TJSON.encode(data, 'fancy');
	}
}

class TextDatabase {
	var db:Map<String, TextEntry>;
	
	public function new() {
		db = new Map<String, TextEntry>();
	}
	
	public function find(key:String):TextEntry {
		var entry:TextEntry = db.get(key);
		return entry;
	}
	
	public function get(key:String):String {
		var entry:TextEntry = db.get(key);
		
		if (entry == null) return null;
		
		return entry.get(Tobor.locale);
	}
	
	public function set(key:String, txt:String, ?lang:String = null) {
		if (lang == null) lang = Tobor.defaultLocale;
		
		var entry:TextEntry = db.get(key);
		
		if (entry == null) {
			entry = new TextEntry(key);
			db.set(key, entry);
		}
		
		entry.set(lang, txt);
	}
	
	public function save():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		for (key in db.keys()) {
			var v = db.get(key).save();
			if (v != null) data.set(key, v);
		}
		
		return data;
	}
	
	public function saveMissing():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		for (key in db.keys()) {
			var v = db.get(key).saveMissing();
			if (v != null) data.set(key, v);
		}
		
		return data;
	}
	
	public function toString():String {
		var r:String = "";
		
		for (key in db.keys()) {
			r = r + key + ": (" + db.get(key) + ")\n";
		}
		
		return r;
	}
}

class TextEntry {
	var key:String;
	var db:Map<String, String>;
	
	public function new(key:String) {
		this.key = key;
		db = new Map<String, String>();
	}
	
	public function set(lang:String, text:String) {
		db.set(lang, text);
	}
	
	public function get(lang:String):String {
		// String in gewünschter Sprache holen
		var value:String = db.get(lang);
		
		if (value == null) {
			// ansonsten String in Standardsprache holen
			value = db.get(Tobor.defaultLocale);
		}
		
		return value;
	}
	
	public function save():Map<String, String> {
		var data:Map<String, String> = new Map<String, String>();
		
		for (key in db.keys()) {
			if (this.key != db.get(key)) data.set(key, db.get(key));
		}
		
		if (Lambda.count(data) == 0) return null;
		
		return data;
	}
	
	public function saveMissing():Map<String, String> {
		var data:Map<String, String> = new Map<String, String>();
		
		for (key in db.keys()) {
			if (this.key == db.get(key)) data.set(key, db.get(key));
		}
		
		if (Lambda.count(data) == 0) return null;
		
		return data;
	}
	
	public function toString():String {
		var r:String = "";
		
		for (key in db.keys()) {
			r = r + key + ": " + db.get(key) + ", ";
		}
		
		return r;
	}
}