package;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;

/**
 * ...
 * @author Matthias Faust
 */
class Input {
	public static var key = KeyCode;
	public static var mod = KeyModifier;
	
	static var lastKeyCode:KeyCode = -1;
	static var waitTime:Float = 0;
	
	static var _keys:Map<KeyCode, Bool> = new Map<KeyCode, Bool>();
	static var _mods:Map<KeyModifier, Bool> = new Map<KeyModifier, Bool>();
	
	static var lastMouseButton:Int = -1;
	public static var _mouseButton:Map<Int, Bool> = new Map<Int, Bool>();
	public static var mouseX:Float;
	public static var mouseY:Float;
	
	public static function onMouseDown(btn:Int) {
		_mouseButton.set(btn, true);
	}
	
	public static function onMouseUp(btn:Int) {
		_mouseButton.set(btn, false);
	}
	
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
		
		if (modifier != KeyModifier.NONE && modifier != KeyModifier.NUM_LOCK) _mods.set(modifier, true);
		_keys.set(keyCode, true);
		
		lastKeyCode = keyCode;
	}
	
	public static function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {
		if (keyCode == lastKeyCode) lastKeyCode = -1;
		waitTime = 0;
		
		if (modifier != KeyModifier.NONE && modifier != KeyModifier.NUM_LOCK) _mods.set(modifier, false);
		_keys.set(keyCode, false);
	}
	
	static function modsDown():Int {
		var count:Int = 0;
		
		for (m in _mods.keys()) {
			if (_mods.get(m) == true) count++;
		}
		
		return count;
	}
	
	public static function isMouseDown(btn:Int):Bool {
		if (waitTime > 0) return false;
		
		if (_mouseButton.get(btn)) return true;
		
		return false;
	}
	
	public static function isKeyDown(_key:Array<KeyCode>, ?keyOnly:Bool = true):Bool {
		if (waitTime > 0) return false;
		
		if (keyOnly) {
			if (modsDown() > 0) return false;
		}
		
		for (k in _key) {
			if (_keys.get(k)) return true;
		}
		
		return false;
	}
	
	public static function isModDown(_key:Array<KeyModifier>):Bool {
		if (waitTime > 0) return false;
		
		for (k in _key) {
			if (_mods.get(k)) return true;
		}
		
		return false;
	}
	
	public static function clearKeys() {
		_keys = new Map<KeyCode, Bool>();
		_mods = new Map<KeyModifier, Bool>();
		_mouseButton = new Map<Int, Bool>();
	}
}