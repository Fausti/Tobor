package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Munition extends EntityCollectable {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(type * 144, 60);
		
		if (spr != null) {
			sprites.push(spr);
		}
	}
	
}