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
	
	public static var mouseBtnLeft:Bool = false;
	public static var mouseBtnMiddle:Bool = false;
	public static var mouseBtnRight:Bool = false;

	// Tastatur
	
	public static var key:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static var ESC = [KeyCode.ESCAPE];
	public static var TAB = [KeyCode.TAB];
	
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