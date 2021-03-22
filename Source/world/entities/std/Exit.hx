package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class Exit extends EntityDynamic {
	
	var spr_closed:Sprite;
	var spr_open_ns:Sprite;
	var spr_open_we:Sprite;
	
	public function new() {
		super();
	}
	
	override public function init() {
		spr_closed = Gfx.getSprite(0, 12);
		spr_open_ns = Gfx.getSprite(32, 12);
		spr_open_we = Gfx.getSprite(16, 12);

		setSprite(spr_closed);
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (room.robots != 0 && room.treeTimer == 0.0) {
			setSprite(spr_closed);
		} else {
			if (x == 0 || x == 39) {
				setSprite(spr_open_we);
			} else if (y == 0 || y == 27) {
				setSprite(spr_open_ns);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (room.treeTimer > 0.0) return true;
		if (room.robots != 0) return false;
		
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) return true;
		
		return false;
	}
}