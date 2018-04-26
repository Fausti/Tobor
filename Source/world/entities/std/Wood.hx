package world.entities.std;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Wood extends EntityFloor {
	public static var SPR_WOOD:Array<Sprite> = Gfx.getSprites(null, 0, 252, 0, 8);
	
	static var FULL_TILES = [0, 5, 6];
	static var HALF_TILES = [
		Direction.NW => [1],
		Direction.SW => [2],
		Direction.NE => [4],
		Direction.SE => [3]
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
		
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WOOD[type]);
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