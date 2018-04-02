package world.entities.std;

import world.entities.Entity;
import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Grass extends EntityStatic {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		for (i in 0 ... 2) {
			spr = Gfx.getSprite(128 + 16 * type, 252);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		
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