package world.entities.std;

import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class Exit extends EntityDynamic {
	
	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		switch (type) {
			case 0: // geschlossen
				spr = Gfx.getSprite(0, 12);
			case 1: // W <-> E
				spr = Gfx.getSprite(16, 12);
			case 2: // N <-> S
				spr = Gfx.getSprite(32, 12);
			default:
				spr = Gfx.getSprite(0, 12);
		}
		
		if (spr != null) {
			sprites.push(spr);
		}
	}
}