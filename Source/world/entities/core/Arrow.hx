package world.entities.core;

import gfx.Sprite;
import lime.math.Rectangle;
import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Arrow extends Object {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_E")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_N")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_W")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_S"))
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		gfx = SPRITES[type];
	}
	
	override public function canEnter(e:Object):Bool {
		if (isPlayer(e)) {
			if (e.gridX < gridX && type == 0) {
				return true;
			} else if (e.gridX > gridX && type == 2) {
				return true;
			} else if (e.gridY < gridY && type == 3) {
				return true;
			} else if (e.gridY > gridY && type == 1) {
				return true;
			}
		}
		
		return false;
	}
}