package world.entities;

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
}