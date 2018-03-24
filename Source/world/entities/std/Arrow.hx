package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Arrow extends EntityStatic {
	var SPR_ARROW:Array<Sprite>;
	
	public function new() {
		super();
		
		SPR_ARROW = [];
		
		for (i in 0 ... 4) {
			SPR_ARROW.push(Gfx.getSprite(96 + 16 * i, 24));
		}
	}
	
	override public function render() {
		setSprite(SPR_ARROW[type]);
		super.render();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			if (type == 0 && direction == Direction.E) return true;
			else if (type == 1 && direction == Direction.N) return true;
			else if (type == 2 && direction == Direction.W) return true;
			else if (type == 3 && direction == Direction.S) return true;
			
			return false;
		}
		
		return false;
	}
	
	public function rotate(r:Int) {
		if (r == -1) {
			type = type + 1;
			if (type >= 4) type = 0;
		} else if (r == 1) {
			type = type - 1;
			if (type <= -1) type = 3;
		}
	}
}