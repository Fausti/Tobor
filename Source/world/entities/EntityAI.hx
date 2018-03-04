package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class EntityAI extends EntityMoveable {
	public function new() {
		super();
	}
	
	
	override public function update(deltaTime:Float) {
		if (!isMoving()) {
			idle();
		}
		
		super.update(deltaTime);
	}
	
	function idle() {
		
	}
}