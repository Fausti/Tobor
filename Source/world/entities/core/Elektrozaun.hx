package world.entities.core;

import world.entities.Object;
import world.entities.ObjectPushable;

/**
 * ...
 * @author Matthias Faust
 */
class Elektrozaun extends ObjectPushable {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_ELEKTROZAUN"));
	}
	
	
	override public function canEnter(e:Object):Bool {
		if (Std.is(e, Charlie)) {
			return true;
		} else if (Std.is(e, ObjectAI)) {
			return true;
		}
		
		return super.canEnter(e);
	}
	
	override public function onEnter(e:Object) {
		if (Std.is(e, Charlie) || Std.is(e, ObjectAI)) {
			destroy();
			e.die();
		}
		
		super.onEnter(e);
	}
}