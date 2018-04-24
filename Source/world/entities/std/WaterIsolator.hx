package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityFloor;

/**
 * ...
 * @author Matthias Faust
 */
class WaterIsolator extends EntityFloor {
	public static var SPR_WATER_ISOLATOR = Gfx.getSprite(112, 156);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WATER_ISOLATOR);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, Isolator) || Std.is(e, EntityAI)) {
			return true;
		}
		
		return false;
	}
	
}