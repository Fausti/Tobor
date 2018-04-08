package world.entities.std;

import world.entities.EntityDynamic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Barrier extends EntityDynamic {
	
	var spr_closed:Sprite;
	var spr_open:Sprite;
	
	public function new() {
		super();
	}
	
	override public function init() {
		spr_closed = Gfx.getSprite(240, 96);
		spr_open = Gfx.getSprite(224, 96);

		setSprite(spr_closed);
	}
	
	override public function render() {
		if (room.treeTimer > 0.0) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr_open);
		} else {
			if (room.robots != 0) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr_closed);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr_open);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (room.treeTimer > 0.0) return true;
		if (room.robots != 0) return false;
		
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		
		return false;
	}
}