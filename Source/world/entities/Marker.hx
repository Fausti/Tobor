package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class Marker extends Entity {

	public static inline var MARKER_NO:Int = -1;
	
	public static inline var MARKER_0:Int = 0;
	public static inline var MARKER_1:Int = 1;
	public static inline var MARKER_2:Int = 2;
	public static inline var MARKER_3:Int = 3;
	public static inline var MARKER_4:Int = 4;
	
	static var _SPR_MARKER_0:Sprite = null;
	static var _SPR_MARKER_1:Sprite = null;
	static var _SPR_MARKER_2:Sprite = null;
	static var _SPR_MARKER_3:Sprite = null;
	static var _SPR_MARKER_4:Sprite = null;
	
	public static var SPR_MARKER_0(get, null):Sprite;
	public static var SPR_MARKER_1(get, null):Sprite;
	public static var SPR_MARKER_2(get, null):Sprite;
	public static var SPR_MARKER_3(get, null):Sprite;
	public static var SPR_MARKER_4(get, null):Sprite;
	
	public function new() {
		super();
	}
	
	public static function get_SPR_MARKER_0():Sprite {
		if (_SPR_MARKER_0 == null) {
			_SPR_MARKER_0 = Gfx.getSprite(0, 348);
		}
		
		return _SPR_MARKER_0;
	}
	
	public static function get_SPR_MARKER_1():Sprite {
		if (_SPR_MARKER_1 == null) {
			_SPR_MARKER_1 = Gfx.getSprite(16, 348);
		}
		
		return _SPR_MARKER_1;
	}
	
	public static function get_SPR_MARKER_2():Sprite {
		if (_SPR_MARKER_2 == null) {
			_SPR_MARKER_2 = Gfx.getSprite(32, 348);
		}
		
		return _SPR_MARKER_2;
	}
	
	public static function get_SPR_MARKER_3():Sprite {
		if (_SPR_MARKER_3 == null) {
			_SPR_MARKER_3 = Gfx.getSprite(48, 348);
		}
		
		return _SPR_MARKER_3;
	}
	
	public static function get_SPR_MARKER_4():Sprite {
		if (_SPR_MARKER_4 == null) {
			_SPR_MARKER_4 = Gfx.getSprite(64, 348);
		}
		
		return _SPR_MARKER_4;
	}
}