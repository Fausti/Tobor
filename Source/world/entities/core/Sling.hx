package world.entities.core;

import gfx.Sprite;
import lime.math.Rectangle;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Sling extends ObjectItem {
	var SPR_SCHLEUDER:Sprite;
	
	public function new(?type:Int=0) {
		super(type);
	
		SPR_SCHLEUDER = new Sprite(Tobor.Tileset.find("SPR_SCHLEUDER"));
		
		gfx = SPR_SCHLEUDER;
	}
	
}