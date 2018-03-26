package world;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Direction {
	public static var NONE(default, null):Vector2 = new Vector2(0, 0);
	
	public static var S(default, null):Vector2 = new Vector2(0, 1);
	public static var N(default, null):Vector2 = new Vector2(0, -1);
	public static var W(default, null):Vector2 = new Vector2( -1, 0);
	public static var E(default, null):Vector2 = new Vector2(1, 0);
	
	public static var NW(default, null):Vector2 = N.add(W);
	public static var NE(default, null):Vector2 = N.add(E);
	public static var SW(default, null):Vector2 = S.add(W);
	public static var SE(default, null):Vector2 = S.add(E);
	
	public static var ALL:Array<Vector2> = [NONE, S, N, W, E, NW, NE, SW, SE];
	
	public static function get(x:Float, y:Float):Vector2 {
		for (dir in ALL) {
			if (dir.x == x && dir.y == y) return dir;
		}
		
		return NONE;
	}
	
	public static function isDiagonal(d:Vector2):Bool {
		if (d == NW || d == NE || d == SW || d == SE) return true;
		return false;
	}
	
	public static function getRandomAll():Vector2 {
		return Direction.ALL[Std.random(Direction.ALL.length)];
	}
	
	public static function getRandom():Vector2 {
		return Direction.ALL[Std.random(Direction.ALL.length - 1) + 1];
	}
	
	public static function rotate(d:Vector2, ?clockwise:Bool = true):Vector2 {
		if (d == N) {
			if (clockwise) return NE;
			else return NW;
		}
		
		if (d == S) {
			if (clockwise) return SW;
			else return SE;
		}
		
		if (d == W) {
			if (clockwise) return NW;
			else return SW;
		}
		
		if (d == E) {
			if (clockwise) return SE;
			else return NE;
		}
		
		if (d == NW) {
			if (clockwise) return N;
			else return W;
		}
		
		if (d == NE) {
			if (clockwise) return E;
			else return N;
		}
		
		if (d == SE) {
			if (clockwise) return S;
			else return E;
		}
		
		if (d == SW) {
			if (clockwise) return W;
			else return S;
		}
		
		return NONE;
	}
}