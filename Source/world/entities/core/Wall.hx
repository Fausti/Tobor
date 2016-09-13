package world.entities.core;


/**
 * ...
 * @author Matthias Faust
 */
class Wall extends Object {
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
			case 6:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_BLACK"));
			case 7:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_BLACK_SW"));
			case 8:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_BLACK_NE"));
			case 9:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_BLACK_NW"));
			case 10:
				gfx = new Sprite(Tobor.Tileset.find("SPR_MAUER_BLACK_SE"));
			default:
		}
	}
	
	override
	public function canEnter(e:Object):Bool {
		return false;
	}
}