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
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_MOUNTAIN[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}