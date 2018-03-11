package world.entities.std;

import gfx.Gfx;
import gfx.Sprite;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Wall extends EntityStatic {
	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		switch (type) {
			case 0: // normale Wand
				spr = Gfx.getSprite(160, 0);
			case 1:
				spr = Gfx.getSprite(160 + 16 * 1, 0);
			case 2:
				spr = Gfx.getSprite(160 + 16 * 2, 0);
			case 3:
				spr = Gfx.getSprite(160 + 16 * 3, 0);
			case 4:
				spr = Gfx.getSprite(160 + 16 * 4, 0);
				
			case 5: // schwarze Wand
				spr = Gfx.getSprite(48, 132);
			case 6:
				spr = Gfx.getSprite(48 + 16 * 1, 132);
			case 7:
				spr = Gfx.getSprite(48 + 16 * 2, 132);
			case 8:
				spr = Gfx.getSprite(48 + 16 * 3, 132);
			case 9:
				spr = Gfx.getSprite(48 + 16 * 4, 132);
				
			case 10: // feste rote Wand
				spr = Gfx.getSprite(160, 12);
			default:
				spr = Gfx.getSprite(160, 0);
		}
		
		if (spr != null) {
			sprites.push(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
	
	override public function parseData(data) {
		super.parseData(data);
		
		if (hasData(data, "type")) {
			this.type = data.type;
			init();
		}
	}
}