package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Bridge extends EntityStatic {
	public static var ON_GROUND:Int = Room.LAYER_LEVEL_0 + 1;
	public static var UNDER_BRIDGE:Int = Room.LAYER_LEVEL_1 - 1;
	public static var ON_BRIDGE:Int = Room.LAYER_LEVEL_1 + 1;
	
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
		// Prüfen ob Entity von Brücke kommt...
		var fromBridge:Bool = false;
		var sameBridge:Bool = false;
			
		var fromList:Array<Entity> = room.findEntityAt(e.x, e.y, Type.getClass(this));
		if (fromList.length > 0) fromBridge = true;
		for (ee in fromList) {
			if (ee.type == type) sameBridge = true;
		}
			
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			switch(type) {
				case 0:
					if (direction == Direction.N || direction == Direction.S) {
						if (!fromBridge) return true;
						else {
							if (sameBridge) return true;
						}
					}
				case 1:
					if (direction == Direction.W || direction == Direction.E) {
						if (!fromBridge) return true;
						else {
							if (sameBridge) return true;
						}
					}
			}
		} else {
			switch(type) {
				case 0:
					if (direction == Direction.W || direction == Direction.E) return true;
				case 1:
					if (direction == Direction.N || direction == Direction.S) return true;
			}
		}
		
		return false;
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			switch(type) {
				case 0:
					if (direction == Direction.N || direction == Direction.S) {
						e.z = ON_BRIDGE;
					} else e.z = ON_GROUND;
				case 1:
					if (direction == Direction.W || direction == Direction.E) {
						e.z = ON_BRIDGE;
					} else e.z = ON_GROUND;
				default:
			}
		}
	}
}