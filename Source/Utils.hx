package;

/**
 * ...
 * @author Matthias Faust
 */
class Utils {
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float {
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}