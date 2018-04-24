package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class SandDeco extends EntityFloor {
	var SPR_SAND_DECO:Array<Sprite>;
	
	public function new() {
		super();
	
		SPR_SAND_DECO = [
			Gfx.getSprite(208, 132),
			Gfx.getSprite(208 + 16, 132),
			Gfx.getSprite(208 + 32, 132)
		];
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		// Wenn Ring#2 im Inventar und Ringeffekte aktiv, keine Verlangsamung
		if (getWorld().checkRingEffect(3) && Std.is(e, Charlie)) return;
		
		// Wenn Nahrungstimer aktiv, keine Verlangsamung
		if (getWorld().food > 0 && Std.is(e, Charlie)) return;
		
		var ee:EntityMoveable = cast e;
		ee.changeSpeed((speed) / 2);
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SAND_DECO[type]);
	}
}