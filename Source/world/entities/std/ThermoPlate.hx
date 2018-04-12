package world.entities.std;

import world.entities.EntityStatic;
import world.entities.interfaces.IElectric;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class ThermoPlate extends EntityStatic implements IElectric {
	var SPR_HEAT:Sprite;
	var SPR_FROST:Sprite;
	
	public function new() {
		super();
		
		SPR_HEAT = Gfx.getSprite(160, 324);
		SPR_FROST = Gfx.getSprite(176, 324);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_HEAT);
			case 1:
				setSprite(SPR_FROST);
		}
		
		super.render();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI) || Std.is(e, EntityMoveable)) return true;
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
	
	override public function switchStatus() {
		if (type == 0) {
			type = 1;
			
			if (room.getAllEntitiesAt(x, y, this).length == 0) {
				var iceBlock:IceBlock = new IceBlock();
				iceBlock.flag = flag;
				
				room.spawnEntity(x, y, iceBlock);
			}
			
		} else {
			type = 0;
			
			for (iceBlock in room.findAll(IceBlock)) {
				if (iceBlock.flag == flag) {
					iceBlock.die();
				}
			}
		}
	}
}