package;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;

/**
 * ...
 * @author Matthias Faust
 */
class Input {
	public static var key = KeyCode;
	
	static var lastKeyCode:KeyCode = -1;
	static var waitTime:Float = 0;
	
	static var _keys:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static function update(deltaTime:Float) {
		if (waitTime > 0) {
			waitTime = waitTime - deltaTime;
			
			if (waitTime < 0) waitTime = 0;
		}
	}
	
	public static function wait(time:Float) {
		waitTime = time;
	}
	
	public static function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void {
		if (keyCode == lastKeyCode) return;
		
		_keys.set(keyCode, true);
		lastKeyCode = keyCode;
	}
	
	public static function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {
		if (keyCode == lastKeyCode) lastKeyCode = -1;
		waitTime = 0;
		
		_keys.set(keyCode, false);
	}
	
	public static function isKeyDown(_key:Array<KeyCode>):Bool {
		if (waitTime > 0) return false;
		
		for (k in _key) {
			if (_keys.get(k)) return true;
		}
		
		return false;
	}
	
	public static function clearKeys() {
		_keys = new Map<KeyCode, Bool>();
	}
}