package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Door extends EntityStatic {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(type * 16, 36);
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		// Charlie nur mit Schlüssel
		if (Std.is(e, Charlie)) {
			return room.world.inventory.hasItem("OBJ_KEY#" + type);
		}
		
		// Roboter nur wenn Charlie AUF der Tür steht
		if (Std.is(e, Robot)) {
			if (getPlayer().gridX == gridX && getPlayer().gridY == gridY) return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			Sound.play(Sound.SND_OPEN_DOOR);
		}
		
		super.onEnter(e, direction);
	}
}