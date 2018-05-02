package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Arrow extends EntityStatic {
	public static var SPR_ARROW:Array<Sprite> = Gfx.getSprites([], 96, 24, 0, 4);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_ARROW[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			var player = getPlayer();
			
			// steht Charlie auf dem Pfeil, gelten die Richtungen nicht mehr für Roboter!
			if (Std.is(e, EntityAI)) {
				if (player.x == x && player.y == y) return true;
			}
			
			// ohne Charlie können Androiden keine Pfeile betreten
			if (Std.is(e, Android)) return false;
			
			if (type == 0 && direction == Direction.E) return true;
			else if (type == 1 && direction == Direction.N) return true;
			else if (type == 2 && direction == Direction.W) return true;
			else if (type == 3 && direction == Direction.S) return true;
			
			return false;
		}
		
		return false;
	}
	
	public function rotate(r:Int) {
		if (r == -1) {
			type = type + 1;
			if (type >= 4) type = 0;
		} else if (r == 1) {
			type = type - 1;
			if (type <= -1) type = 3;
		}
	}
}