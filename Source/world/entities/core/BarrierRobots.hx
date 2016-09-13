package world.entities.core;

import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class BarrierRobots extends Object {

	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_BLOCKADE_ROBOTER_AKTIV")),
			new Sprite(Tobor.Tileset.find("SPR_BLOCKADE_ROBOTER_INAKTIV"))
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		type = 1;
		
		gfx = SPRITES[type];
	}
	
	override public function canEnter(e:Object):Bool {
		if (Std.is(e, ObjectAI) || e == room.world.player) {
			if (type > 0) {
				return true;
			}
		}
		
		return false;
	}
	
	override public function onCreate() {
		updateSprite();
	}
	
	override public function saveData():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var id:Int = EntityFactory.findID("OBJ_BLOCKADE_ROBOTER", 0);
		var def:EntityTemplate = EntityFactory.table[id];
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("x", gridX);
			data.set("y", gridY);
		}
		
		return data;
	}
}