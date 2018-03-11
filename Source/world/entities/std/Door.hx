package world.entities.std;

import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Door extends EntityStatic {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(type * 16, 36);
		
		if (spr != null) {
			sprites.push(spr);
		}
	}
}