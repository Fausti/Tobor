package world.entities.std;

import world.entities.Entity;
import world.entities.EntityStatic;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class SandPlant extends EntityStatic {
	var SPR_SAND_PLANT:Array<Sprite>;
	
	public function new() {
		super();
		
		SPR_SAND_PLANT = [
			Gfx.getSprite(0, 168),
			Gfx.getSprite(16, 168),
			Gfx.getSprite(32, 168)
		];
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SAND_PLANT[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, EntityAI) && type > 0) return true;
		
		if (Std.is(e, Charlie)) {
			if (type == 0) {
				if (getInventory().hasItem("OBJ_KNIFE")) return true;
				return false;
			} else {
				return true;
			}
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (type == 0) {
				if (getInventory().hasItem("OBJ_KNIFE")) {
					die();
				}
			} else if (type == 1) {
				type = 2;
			}
		}
		
		super.onEnter(e, direction);
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