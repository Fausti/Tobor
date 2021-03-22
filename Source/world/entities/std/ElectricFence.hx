package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityPushable;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class ElectricFence extends EntityPushable implements IElectric {
	var SPR_DISABLED:Sprite;
	var SPR_ENABLED:Sprite;
	
	public function new() {
		super();
		
		SPR_DISABLED = Gfx.getSprite(96, 156);
		SPR_ENABLED = Gfx.getSprite(64, 12);
		
		setSprite(SPR_ENABLED);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_ENABLED);
			case 1:
				setSprite(SPR_DISABLED);
		}
		
		super.render();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) {
			if (Std.isOfType(e, Robot)) {
				// steht Charlie auf dem Zaun?
				if (getPlayer().gridX == x && getPlayer().gridY == y) return true;
				
				// ... Roboter haben Hemmungen in den Zaun zu laufen!
				if (Utils.chance(85)) return false;
			} else if (Std.isOfType(e, Android)) {
				return false;
			}
			
			return true;
		}
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (type == 0) {
			if (Std.isOfType(e, EntityAI)) {
				e.die();
				die();
			} else if (Std.isOfType(e, Charlie)) {
				if (!getPlayer().hasOverall()) {
					
					if (getWorld().checkFirstUse("KILLED_BY_EFENCE")) {
					
					} else {
						getWorld().markFirstUse("KILLED_BY_EFENCE");
						getWorld().showPickupMessage("KILLED_BY_EFENCE", false, function () {
							getWorld().hideDialog();
						});
					}
					
					e.die();
					die();
				}
			}
		}
	}
	
	override public function switchStatus() {
		if (type == 0) type = 1; else type = 0;
	}
}