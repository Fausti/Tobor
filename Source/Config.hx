package;

import tjson.TJSON;
/**
 * ...
 * @author Matthias Faust
 */
class Config {

	public static var speed:Int = 2;
	static var _speeds:Array<Float> = [0.5, 0.75, 1, 1.5, 2];
	
	public static function init() {
		load();
	}
	
	public static function load() {
		var fileData:String = Files.loadFromFile("config.json");
		if (fileData == null) return;
		
		var data = TJSON.parse(fileData);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "speed":
				speed = Reflect.field(data, "speed");
			}
		}
	}
	
	public static function save() {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		data.set("speed", speed);
		
		Files.saveToFile("config.json", TJSON.encode(data, 'fancy'));
	}
	
	public static function setSpeed(index:Int) {
		if (index < 0) index = 0;
		if (index >= _speeds.length) index = _speeds.length - 1;
		
		speed = index;
		
		save();
	}
	
	public static function getSpeed(v:Float):Float {
		return v * _speeds[speed];
	}
}