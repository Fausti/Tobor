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
}