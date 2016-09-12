package world;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Direction {
	public static inline var NONE:Int = 0;
	
	public static inline var LEFT:Int = 1;
	public static inline var UP:Int = 2;
	public static inline var RIGHT:Int = 3;
	public static inline var DOWN:Int = 4;
	
	static var table:Array<Vector2> = [
		new Vector2(0, 0),
		new Vector2( -1, 0),
		new Vector2(0, -1),
		new Vector2(1, 0),
		new Vector2(0, 1)
	];
	
	public static function get(arg0:Int, ?arg1:Int):Vector2 {
		if (arg1 == null) {
			return table[arg0];
		} else {
			if (arg0 < 0) {
				return table[LEFT];
			} else if (arg0 > 0) {
				return table[RIGHT];
			} else if (arg1 < 0) {
				return table[UP];
			} else if (arg1 > 0) {
				return table[DOWN];
			}
		}
		
		return table[NONE];
	}
}