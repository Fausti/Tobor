package world.entities.std;

import world.entities.EntityStatic;
import world.entities.interfaces.IElectric;

import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class Mirror extends EntityStatic implements IElectric {
	var SPR_TYPE_0:Sprite;
	var SPR_TYPE_1:Sprite;
	
	public function new() {
		super();
		
		SPR_TYPE_0 = Gfx.getSprite(32, 324);
		SPR_TYPE_1 = Gfx.getSprite(48, 324);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_TYPE_0);
			case 1:
				setSprite(SPR_TYPE_1);
		}
		
		super.render();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {	
		return false;
	}
	
	override public function switchStatus() {
		if (type == 0) type = 1; else type = 0;
	}
}