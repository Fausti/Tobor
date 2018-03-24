package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Skull extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(80, 12));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			for (xx in Std.int(x - 1) ... Std.int(x + 2)) {
				for (yy in Std.int(y - 1) ... Std.int(y + 2)) {
					spawnFence(xx, yy);
				}
			}
			
			die();
		}
	}
	
	function spawnFence(fx:Float, fy:Float) {
		if (Room.isOutsideMap(fx, fy)) return;
		
		if (room.getEntitiesAt(fx, fy).length == 0) {
			var fence:ElectricFence = new ElectricFence();
			room.spawnEntity(fx, fy, fence);
		}
	}
}