package world.entities.std;

import world.entities.EntityDynamic;
import world.entities.interfaces.IElectric;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class RobotFactory extends EntityDynamic implements IElectric {
	var SPR_DISABLED:Sprite;
	var SPR_ENABLED:Sprite;
	
	public function new() {
		super();
		
		SPR_DISABLED = Gfx.getSprite(0, 324);
		SPR_ENABLED = Gfx.getSprite(16, 324);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_DISABLED);
			case 1:
				setSprite(SPR_ENABLED);
		}
		
		super.render();
	}
	
	override public function update(deltaTime:Float) {
		if (type == 1) {
			if (room.robots == 0) {
				var robot:Robot = new Robot();
				robot.init();
			
				room.spawnEntity(x, y, robot);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
	
	override public function switchStatus() {
		if (type == 0) type = 1; else type = 0;
	}
}