package world.entities.std;

import gfx.Gfx;
import gfx.Sprite;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Wall extends EntityStatic {
	public static var SPR_WALL:Array<Sprite> = [
		// rote Wand
		Gfx.getSprite(160, 0),
		Gfx.getSprite(160 + 16 * 1, 0),
		Gfx.getSprite(160 + 16 * 2, 0),
		Gfx.getSprite(160 + 16 * 3, 0),
		Gfx.getSprite(160 + 16 * 4, 0),
		
		// schwarze Wand
		Gfx.getSprite(48, 132),
		Gfx.getSprite(48 + 16 * 1, 132),
		Gfx.getSprite(48 + 16 * 2, 132),
		Gfx.getSprite(48 + 16 * 3, 132),
		Gfx.getSprite(48 + 16 * 4, 132),
				
		// feste rote Wand
		Gfx.getSprite(160, 12),
				
		// Sand Wand
		Gfx.getSprite(32, 120),
		Gfx.getSprite(32 + 16 * 1, 120),
		Gfx.getSprite(32 + 16 * 2, 120),
		Gfx.getSprite(32 + 16 * 3, 120),
		Gfx.getSprite(32 + 16 * 4, 120)
	];
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WALL[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}