package world.entities.core;

import world.entities.Entity;
import gfx.Sprite;

/**
 * ...
 * @author Matthias Faust
 */
class Exit extends Entity {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_AUSGANG")),
			new Sprite(Tobor.Tileset.find("SPR_AUSGANG_WE")),
			new Sprite(Tobor.Tileset.find("SPR_AUSGANG_NS"))
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		if (gridX == 0 || gridX == 39) {
			type = 1;
		} else if (gridY == 0 || gridY == 27) {
			type = 2;
		} else {
			type = 0;
		}
		
		gfx = SPRITES[type];
	}
	
	override public function canEnter(e:Entity):Bool {
		if (Std.is(e, EntityAI) || e == room.world.player) {
			if (type > 0) {
				return true;
			}
		}
		
		return false;
	}
	
	override public function onCreate() {
		updateSprite();
	}
	
	override public function save():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var id:Int = EntityFactory.findID("OBJ_AUSGANG", 0);
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