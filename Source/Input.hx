package;
import lime.ui.KeyCode;

/**
 * ...
 * @author Matthias Faust
 */
class Input {
	static var waitTime:Float = 0.0;
	
	// Maus
	
	public static var mouseInside:Bool = true;
	public static var mouseX:Int;
	public static var mouseY:Int;
	
	public static var mouseBtnLeft:Bool = false;
	public static var mouseBtnMiddle:Bool = false;
	public static var mouseBtnRight:Bool = false;

	// Tastatur
	
	public static var key:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static var PAGE_UP = [KeyCode.PAGE_UP];
	public static var PAGE_DOWN = [KeyCode.PAGE_DOWN];
	
	public static var NUM_1 = [KeyCode.NUMBER_1, KeyCode.NUMPAD_1];
	
	public static var F1 = [KeyCode.F1];
	public static var F2 = [KeyCode.F2];
	public static var F3 = [KeyCode.F3];
	public static var F4 = [KeyCode.F4];
	public static var F5 = [KeyCode.F5];
	
	public static var ESC = [KeyCode.ESCAPE];
	public static var TAB = [KeyCode.TAB];
	public static var ENTER = [KeyCode.RETURN, KeyCode.NUMPAD_ENTER];
	
	public static var UP = [KeyCode.W, KeyCode.UP];
	public static var DOWN = [KeyCode.S, KeyCode.DOWN];
	public static var LEFT = [KeyCode.A, KeyCode.LEFT];
	public static var RIGHT = [KeyCode.D, KeyCode.RIGHT];
	
	public static function wait(time:Float) {
		waitTime = time;
	}
	
	public static function update(deltaTime:Float) {
		if (waitTime > 0.0) {
			if (deltaTime > waitTime) deltaTime = waitTime;
		
			waitTime -= deltaTime;
			
			if (waitTime < 0) waitTime = 0.0;
		}
	}
	
	public static function setKey(keyCode:KeyCode, value:Bool) {
		key[keyCode] = value;
		
		if (value == false) {
			waitTime = 0.0;
		}
	}
	
	public static inline function keyDown(k:Array<KeyCode>):Bool {
		if (waitTime > 0.0) return false;
		
		var down = false;
		
		for (i in k) {
			if (key[i]) down = true;
		}
		
		return down;
	}
	
	public static inline function mouseReset() {
		mouseBtnLeft = false;
		mouseBtnMiddle = false;
		mouseBtnRight = false;
	}
}