package;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;

/**
 * ...
 * @author Matthias Faust
 */
class Input {
	public static var key = KeyCode;
	
	static var _keys:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	
	public static function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void {
		_keys.set(keyCode, true);
	}
	
	public static function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {
		_keys.set(keyCode, false);
	}
	
	public static function down(keys:Array<KeyCode>):Bool {
		var v:Bool = false;
		
		for (k in keys) {
			v = v || _keys.get(k);
		}
		
		return v;
	}
}