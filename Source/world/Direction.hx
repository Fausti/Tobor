package world;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Direction {
	public static var NONE(default, null):Vector2 = new Vector2(0, 0);
	public static var DOWN(default, null):Vector2 = new Vector2(0, 1);
	public static var UP(default, null):Vector2 = new Vector2(0, -1);
	public static var LEFT(default, null):Vector2 = new Vector2( -1, 0);
	public static var RIGHT(default, null):Vector2 = new Vector2(1, 0);
}