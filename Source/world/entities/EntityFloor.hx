package world.entities;

import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class EntityFloor extends EntityStatic {
	
	public function new() {
		super();
		
		z = Room.LAYER_FLOOR;
	}
	
	override public function init() {
		super.init();
		
		z = Room.LAYER_FLOOR;
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
}