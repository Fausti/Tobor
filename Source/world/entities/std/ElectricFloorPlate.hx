package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.interfaces.IElectric;
import world.entities.interfaces.IWeight;

/**
 * ...
 * @author Matthias Faust
 */
class ElectricFloorPlate extends EntityStatic implements IElectric {
	var SPR_DISABLED:Sprite;
	var SPR_ENABLED:Sprite;
	
	public function new() {
		super();
		
		SPR_DISABLED = Gfx.getSprite(32, 336);
		SPR_ENABLED = Gfx.getSprite(48, 336);
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
		if (Std.is(e, Charlie) || Std.is(e, EntityAI) || Std.is(e, EntityMoveable)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (this.flag != Marker.MARKER_NO) {
			if (type == 0) {
				var onMe = room.findEntityAt(x, y, IWeight);
				if (onMe.length > 0) {
					type = 1;
					room.switchStatus(this.flag, this);
				}
			}
		}
	}
	
	override public function onLeave(e:Entity, direction:Vector2) {
		if (this.flag != Marker.MARKER_NO) {
			if (type == 1) {
				var onMe = room.findEntityAt(x, y, IWeight);
				onMe.remove(e); // e aus der Liste entfernen, Event kommt wenn e noch auf dem Feld steht!
				if (onMe.length == 0) {
					type = 0;
					room.switchStatus(this.flag, this);
				}
			}
		}
	}
	
	override public function switchStatus() {
		
	}
}