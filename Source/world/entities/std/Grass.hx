package world.entities.std;

import world.entities.Entity;
import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Grass extends EntityFloor {
	public static var SPR_GRASS:Array<Sprite> = [
		Gfx.getSprite(128 + 16 * 0, 252),
		Gfx.getSprite(128 + 16 * 1, 252)
	];
	
	public function new() {
		super();
	}

	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_GRASS[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie) && type == 0) {
			type = 1;
			
			init();
		}
		
		super.onEnter(e, direction);
	}
}