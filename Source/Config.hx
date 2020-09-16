package;
import haxe.Json;

/**
 * ...
 * @author Matthias Faust
 */
class Config {

	public static var speed:Int = 2;
	static var _speeds:Array<Float> = [0.5, 0.75, 1, 1.25, 1.5];
	
	public static var colorKeys:Bool = true;
	
	public static var robotStress:Bool = false;
	public static var robotBehavior:Int = 1;
	
	public static var shader:Int = -1;
	public static var light:Int = 1;
	
	public static function init() {
		load();
	}
	
	public static function load() {
		var fileData:String = Files.loadFromFile("config.json");
		if (fileData == null) return;
		
		var data = Json.parse(fileData);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "speed":
				speed = Reflect.field(data, "speed");
			case "light":
				speed = Reflect.field(data, "light");
			case "shader":
				shader = Reflect.field(data, "shader");
			case "robotStress":
				robotStress = Reflect.field(data, "robotStress");
			case "robotBehavior":
				robotBehavior = Reflect.field(data, "robotBehavior");
			case "colorKeys":
				colorKeys = Reflect.field(data, "colorKeys");
			}
		}
	}
	
	public static function save() {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		data.set("speed", speed);
		data.set("light", light);
		data.set("shader", shader);
		data.set("robotStress", robotStress);
		data.set("robotBehavior", robotBehavior);
		data.set("colorKeys", colorKeys);
		
		Files.saveToFile("config.json", haxe.Json.stringify(data));
	}
	
	public static function setShader(index:Int) {
		shader = index;
		save();
	}
	
	public static function setSpeed(index:Int) {
		if (index < 0) index = 0;
		if (index >= _speeds.length) index = _speeds.length - 1;
		
		speed = index;
		
		save();
	}
	
	public static function setRobotBehavior(index:Int) {
		if (index < 0 || index > 1) return;
		
		robotBehavior = index;
		
		save();
	}
	
	public static function setRobotStress(value:Bool) {
		robotStress = value;
		
		save();
	}
	
	public static function setColoredKeys(value:Bool) {
		colorKeys = value;
		
		save();
	}
	
	public static function getSpeed(v:Float):Float {
		return v * _speeds[speed];
	}
}