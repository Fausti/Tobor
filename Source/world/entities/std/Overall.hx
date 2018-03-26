package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Overall extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(176, 132));
	}
	
	override public function onDrop(x:Float, y:Float) {
		super.onDrop(x, y);
		
		getPlayer().checkForOverall();
	}
}