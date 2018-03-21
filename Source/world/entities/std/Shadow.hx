package world.entities.std;

import world.entities.EntityFloor;

/**
 * ...
 * @author Matthias Faust
 */
class Shadow extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		switch (type) {
			case 0:
				spr = Gfx.getSprite(48, 156);
			case 1:
				spr = Gfx.getSprite(48 + 16, 156);
			case 2:
				spr = Gfx.getSprite(48 + 32, 156);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
	}
}