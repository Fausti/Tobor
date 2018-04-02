package world.entities.std;

import lime.math.Vector2;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Wood extends EntityStatic {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		for (i in 0 ... 7) {
			spr = Gfx.getSprite(0 + 16 * type, 252);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}