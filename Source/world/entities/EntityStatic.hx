package world.entities;
import lime.math.Vector2;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class EntityStatic extends Entity {

	public function new() {
		super();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
}