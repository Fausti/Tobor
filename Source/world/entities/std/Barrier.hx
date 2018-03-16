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
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (room.robots != 0) {
			setSprite(spr_closed);
		} else {
			setSprite(spr_open);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (room.robots != 0) return false;
		
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		
		return false;
	}
}