package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Bank extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(48, 12));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) && getWorld().gold > 0) return true;
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie) && getWorld().gold > 0) {
			var gold:Int = Std.int(Math.min(getWorld().gold, 40));
			
			getWorld().gold = getWorld().gold - gold;
			getWorld().addPoints(gold * 100);
			
			die();
		}
	}
}