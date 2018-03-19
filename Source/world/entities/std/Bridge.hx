package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Bridge extends EntityStatic {

	public function new() {
		super();
		
		this.z = Room.LAYER_LEVEL_1;
	}
	
	override public function init() {
		this.z = Room.LAYER_LEVEL_1;
		
		switch(type) {
			case 0:
				setSprite(Gfx.getSprite(176,156)); // NS
			case 1:
				setSprite(Gfx.getSprite(192,156)); // WE
			default:
				setSprite(Gfx.getSprite(176,156));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			return true;
		}
		
		return false;
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			// Prüfen ob Entity von Brücke kommt...
			var fromBridge:Bool = false;
			var fromList:Array<Entity> = room.findEntityAt(e.x, e.y, Type.getClass(this));
			for (ee in fromList) {
				if (ee.type == type) fromBridge = true;
			}
			
			// müssen wir z des Objektes anpassen?
			switch(type) {
				case 0:
					if (direction == Direction.N || direction == Direction.S) {
						if (e.z != Room.LAYER_LEVEL_1 + 1) {
							if (!fromBridge) e.z = Room.LAYER_LEVEL_1 + 1;
						}
					} else e.z = Room.LAYER_LEVEL_0 + 1;
				case 1:
					if (direction == Direction.W || direction == Direction.E) {
						if (e.z != Room.LAYER_LEVEL_1 + 1) {
							if (!fromBridge) e.z = Room.LAYER_LEVEL_1 + 1;
						}
					} else e.z = Room.LAYER_LEVEL_0 + 1;
				default:
			}
		}
	}
}