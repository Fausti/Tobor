package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Path extends EntityFloor {
	public static var SPR_PATH:Sprite = Gfx.getSprite(224, 120);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_PATH);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.isOfType(e, EntityAI)) return true;
		
		if (Std.isOfType(e, Charlie)) return true;
		
		if (Std.isOfType(e, EntityCollectable)) return true;
		
		if (Std.isOfType(e, ElectricFence)) return true;
		
		return false;
	}
}