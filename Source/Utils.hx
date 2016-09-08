package;

/**
 * ...
 * @author Matthias Faust
 */
class Utils {
	public static function clamp(value:Float, min:Float, max:Float):Float {
		if (value < min) {
			return min;
		} else if (value > max) {
			return max;
		}
		
		return value;
	}
}