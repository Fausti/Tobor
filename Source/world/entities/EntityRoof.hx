package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class EntityRoof extends EntityStatic {

	public function new() {
		super();
		
		z = Room.LAYER_ROOF;
	}
	
	override public function init() {
		super.init();
		
		z = Room.LAYER_ROOF;
	}
	
	override public function render() {
		if (!room.underRoof) super.render();
	}
}