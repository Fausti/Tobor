package;

/**
 * ...
 * @author Matthias Faust
 */
class Utils {
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float {
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
	
	public static function distance(x0:Float, y0:Float, x1:Float, y1:Float):Float {
		return Math.sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
	}
}