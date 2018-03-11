package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Key extends EntityCollectable {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(type * 16, 48);
		
		if (spr != null) {
			sprites.push(spr);
		}
	}
	
}