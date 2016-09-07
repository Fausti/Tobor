package;
import lime.ui.KeyCode;

/**
 * ...
 * @author Matthias Faust
 */
class Input {
	// Maus
	
	public static var mouseInside:Bool = true;
	public static var mouseX:Int;
	public static var mouseY:Int;

	// Tastatur
	
	public static var key:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static var UP = [KeyCode.W, KeyCode.UP];
	public static var DOWN = [KeyCode.S, KeyCode.DOWN];
	public static var LEFT = [KeyCode.A, KeyCode.LEFT];
	public static var RIGHT = [KeyCode.D, KeyCode.RIGHT];
	
	public static inline function keyDown(k:Array<KeyCode>):Bool {
		var down = false;
		
		for (i in k) {
			if (key[i]) down = true;
		}
		
		return down;
	}
}