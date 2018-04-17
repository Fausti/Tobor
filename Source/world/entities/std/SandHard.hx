package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class SandHard extends EntityFloor {
	var SPR_HARD_SAND:Array<Sprite>;
	
	public function new() {
		super();
	
		SPR_HARD_SAND = [
			Gfx.getSprite(208, 144),
			Gfx.getSprite(208 + 16, 144),
			Gfx.getSprite(208 + 32, 144),
			
			Gfx.getSprite(208, 144 + 12),
			Gfx.getSprite(208 + 16, 144 + 12),
			Gfx.getSprite(208 + 32, 144 + 12),
			
			Gfx.getSprite(208 + 16, 144 + 24),
			Gfx.getSprite(208 + 32, 144 + 24)
		];
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_HARD_SAND[type]);
	}
}