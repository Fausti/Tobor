package world.entities.std;

import gfx.Gfx;
import gfx.Sprite;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityFloor;

/**
 * ...
 * @author Matthias Faust
 */
class Wall extends EntityFloor {
	public static var SPR_WALL:Array<Sprite> = [
		// rote Wand
		Gfx.getSprite(160, 0),				// 0
		Gfx.getSprite(160 + 16 * 1, 0),		// 1
		Gfx.getSprite(160 + 16 * 2, 0),		// 2
		Gfx.getSprite(160 + 16 * 3, 0),		// 3
		Gfx.getSprite(160 + 16 * 4, 0),		// 4
		
		// schwarze Wand
		Gfx.getSprite(48, 132),				// 5
		Gfx.getSprite(48 + 16 * 1, 132),	// 6
		Gfx.getSprite(48 + 16 * 2, 132),	// 7
		Gfx.getSprite(48 + 16 * 3, 132),	// 8
		Gfx.getSprite(48 + 16 * 4, 132),	// 9
				
		// feste rote Wand
		Gfx.getSprite(160, 12),				// 10
				
		// Sand Wand
		Gfx.getSprite(32, 120),				// 11
		Gfx.getSprite(32 + 16 * 1, 120),	// 12
		Gfx.getSprite(32 + 16 * 2, 120),	// 13
		Gfx.getSprite(32 + 16 * 3, 120),	// 14
		Gfx.getSprite(32 + 16 * 4, 120),	// 15
		
		// feste gelbe Wand
		Gfx.getSprite(160, 72),				// 16
	];
	
	static var FULL_TILES = [0, 5, 10, 11, 16];
	static var HALF_TILES = [
		Direction.NW => [4, 9, 15],
		Direction.SW => [2, 7, 13],
		Direction.NE => [1, 6, 12],
		Direction.SE => [3, 8, 14]
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
		
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WALL[type]);
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