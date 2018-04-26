package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Mountain extends EntityFloor {
	public static var SPR_MOUNTAIN:Array<Sprite> = [
		Gfx.getSprite(176 + 0 * 16, 264),
		Gfx.getSprite(176 + 1 * 16, 264),
		Gfx.getSprite(176 + 2 * 16, 264),
		Gfx.getSprite(176 + 3 * 16, 264),
		
		Gfx.getSprite(128 + 0 * 16, 288),
		Gfx.getSprite(128 + 1 * 16, 288),
		Gfx.getSprite(128 + 2 * 16, 288),
		Gfx.getSprite(128 + 3 * 16, 288),
		Gfx.getSprite(128 + 4 * 16, 288),
		Gfx.getSprite(128 + 5 * 16, 288),
		Gfx.getSprite(128 + 6 * 16, 288),
		Gfx.getSprite(128 + 7 * 16, 288),
		
		Gfx.getSprite(128 + 0 * 16, 300),
		Gfx.getSprite(128 + 1 * 16, 300),
		Gfx.getSprite(128 + 2 * 16, 300),
		Gfx.getSprite(128 + 3 * 16, 300),
		Gfx.getSprite(128 + 4 * 16, 300),
		Gfx.getSprite(128 + 5 * 16, 300),
		Gfx.getSprite(128 + 6 * 16, 300),
		Gfx.getSprite(128 + 7 * 16, 300),
	];
	
	static var FULL_TILES = [0, 1, 2, 3];
	static var HALF_TILES = [
		Direction.NW => [8, 9, 10, 11],
		Direction.SE => [16, 17, 18, 19],
		Direction.NE => [4, 5, 6, 7],
		Direction.SW => [12, 13, 14, 15]
	];
	
	public function new() {
		super();
		
		fullTiles = FULL_TILES;
		halfTiles = HALF_TILES;
	}
	
	override public function render() {
		// Untergrund zeichnen?
		if (isHalfTile()) {
			renderSubType();
		}
		
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_MOUNTAIN[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
	
	override public function canCombine(e:Entity, ?reverse:Bool = false):Bool {
		return checkCombine(e, reverse);
	}
	
	override public function doCombine(e:Entity, ?reverse:Bool = false) {
		combine(e, reverse);
	}
}