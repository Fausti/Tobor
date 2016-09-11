package world.entities.core;


/**
 * ...
 * @author Matthias Faust
 */
class Mauer extends Entity {
	public function new(?type:Int = 0) {
		super(type);
		
		switch(type) {
			case 0:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER"));
			case 1:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_STABIL"));
			case 2:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_SW"));
			case 3:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_NE"));
			case 4:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_NW"));
			case 5:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_SE"));
			default:
		}
	}
	
	override
	public function isSolid(e:Entity):Bool {
		return true;
	}
}