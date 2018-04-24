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
	public static var SPR_SAND:Array<Sprite> = Gfx.getSprites(null, 0, 24, 0, 5);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SAND[type]);
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