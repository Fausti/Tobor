package world.entities.std;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Wood extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(0 + 16 * type, 252);
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}