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
	
	static var _keys:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void {
		if (keyCode == lastKeyCode) return;
		
		_keys.set(keyCode, true);
		lastKeyCode = keyCode;
	}
	
	public static function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {
		if (keyCode == lastKeyCode) lastKeyCode = -1;
		_keys.set(keyCode, false);
	}
	
	public static function down(_key:Array<KeyCode>):Bool {
		for (k in _key) {
			if (_keys.get(k)) return true;
		}
		
		return false;
	}
	
	public static function clearKeys() {
		_keys = new Map<KeyCode, Bool>();
	}
}