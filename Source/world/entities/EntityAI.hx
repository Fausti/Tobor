package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class EntityAI extends EntityMoveable {
	var waitTicks:Float = 0;
	
	public function new() {
		super();
	}
	
	
	override public function update(deltaTime:Float) {
		if (!isMoving()) {
			if (waitTicks != 0) {
				waitTicks = -1;
				
				if (waitTicks < 0) waitTicks = 0;
			} else {
				idle();
			}
		}
		
		super.update(deltaTime);
	}
	
	function idle() {
		
	}
}