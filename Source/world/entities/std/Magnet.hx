package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Magnet extends EntityCollectable {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		switch (type) {
			case 0:
				spr = Gfx.getSprite(224, 12);
			case 1:
				spr = Gfx.getSprite(240, 12);
			default:
				spr = Gfx.getSprite(224, 12);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
	}
}