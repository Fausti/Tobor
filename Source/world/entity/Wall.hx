package world.entity;

import gfx.Gfx;
import gfx.Sprite;
/**
 * ...
 * @author Matthias Faust
 */
class Wall extends Entity {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("Mauer_0"));
	}
	
	override
	public function isSolid(e:Entity):Bool {
		return true;
	}
}