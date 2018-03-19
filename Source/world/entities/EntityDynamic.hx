package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class EntityDynamic extends Entity {

	public function new() {
		super();
		
		this.z = Room.LAYER_LEVEL_0;
	}
	
}