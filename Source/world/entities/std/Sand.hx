package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Sand extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		super.init();
		
		switch(type) {
			case 0:
				setSprite(Gfx.getSprite(0, 24));
			case 1:
				setSprite(Gfx.getSprite(16, 24));
			case 2:
				setSprite(Gfx.getSprite(32, 24));
			case 3:
				setSprite(Gfx.getSprite(48, 24));
			case 4:
				setSprite(Gfx.getSprite(64, 24));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		// Wenn Ring#2 im Inventar und Ringeffekte aktiv, keine Verlangsamung
		if (getWorld().checkRingEffect(3) && Std.is(e, Charlie)) return;
		
		// Wenn Nahrungstimer aktiv, keine Verlangsamung
		if (getWorld().food > 0 && Std.is(e, Charlie)) return;
		
		var ee:EntityMoveable = cast e;
		ee.changeSpeed((speed) / 2);
	}
}