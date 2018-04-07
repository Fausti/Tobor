package world.entities.std;

import world.entities.EntityStatic;
import world.entities.interfaces.IElectric;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Target extends EntityStatic implements IElectric {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(64, 336));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
}