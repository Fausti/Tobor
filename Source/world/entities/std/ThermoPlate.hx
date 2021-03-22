package world.entities.std;

import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityStatic;
import world.entities.interfaces.IElectric;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class ThermoPlate extends EntityFloor implements IElectric {
	var SPR_HEAT:Sprite;
	var SPR_FROST:Sprite;
	var SPR_DISABLED:Sprite;
	
	public function new() {
		super();
		
		SPR_HEAT = Gfx.getSprite(160, 324);
		SPR_FROST = Gfx.getSprite(176, 324);
		SPR_DISABLED = Gfx.getSprite(192, 324);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_HEAT);
			case 1:
				setSprite(SPR_FROST);
			case 2:
				setSprite(SPR_DISABLED);
		}
		
		super.render();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie)) {
			if (type == 0) {
				// "Hitzeschutz"
				if (getWorld().checkRingEffect(0)) return true;
				
				return false;
			}
			return true;
		}
		
		if (Std.isOfType(e, Robot) || Std.isOfType(e, IceBlock)) return true;
		if (Std.isOfType(e, EntityCollectable)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, IceBlock)) {
			if (type == 0) {
				e.die();
			}
		}
	}
	
	override public function switchStatus() {
		if (type == 0) {
			type = 1;
			
			spawnIce();
		} else if (type == 1 || type == 2) {
			type = 0;
			
			for (iceBlock in room.findAll(IceBlock)) {
				var ib:IceBlock = cast iceBlock;
				
				if (ib.flag == flag) {
					if (ib.timeStamp != getWorld().timeStamp) iceBlock.die();
				}
			}
			
			for (iceBlock in room.findEntityAt(x, y, IceBlock)) {
				iceBlock.die();
			}
		}
	}
	
	public function spawnIce() {
		if (room.getAllEntitiesAt(x, y, this).length == 0) {
			var iceBlock:IceBlock = new IceBlock();
			iceBlock.flag = flag;
			iceBlock.timeStamp = getWorld().timeStamp;
				
			room.spawnEntity(x, y, iceBlock);
		}
	}
}