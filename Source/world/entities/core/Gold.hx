package world.entities.core;

import world.entities.Object;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Gold extends Object {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_GOLD"));
	}
	
	override
	public function canEnter(e:Object):Bool {
		if (Std.is(e, ObjectPushable)) return false;
		
		return true;
	}
	
	override public function onEnter(e:Object) {
		if (isPlayer(e)) {
			destroy();
			room.world.player.gold++;
		}
		
		super.onEnter(e);
	}
}