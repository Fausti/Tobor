package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class WaterPlant extends EntityFloor {
	public static var SPR_WATER_PLANT = Gfx.getSprite(144, 72);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WATER_PLANT);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) {
			return true;
		}
		
		return false;
	}
}