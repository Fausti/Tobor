package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Path extends EntityFloor {
	var SPR_PATH:Sprite;
	
	public function new() {
		super();
		
		SPR_PATH = Gfx.getSprite(224, 120);
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_PATH);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, EntityAI)) return true;
		
		if (Std.is(e, Charlie)) return true;
		
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
}