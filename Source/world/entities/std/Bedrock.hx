package world.entities.std;

import lime.math.Vector2;
import world.entities.EntityFloor;

/**
 * ...
 * @author Matthias Faust
 */
class Bedrock extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		if (type < 9) {
			spr = Gfx.getSprite(0 + 16 * type, 264);
		} else {
			spr = Gfx.getSprite(240, 264);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
}