package world.entities.std;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class ElectricDoor extends EntityStatic implements IElectric {
	var SPR_DISABLED:Sprite;
	var SPR_ENABLED:Sprite;
	
	public function new() {
		super();
		
		SPR_DISABLED = Gfx.getSprite(0, 336);
		SPR_ENABLED = Gfx.getSprite(16, 336);
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
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) {
			if (type == 1) return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie)) {
			Sound.play(Sound.SND_OPEN_DOOR);
		}
		
		super.onEnter(e, direction);
	}
	
	override public function switchStatus() {
		if (type == 0) type = 1; else type = 0;
	}
}