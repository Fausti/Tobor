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

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(160, 0));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}