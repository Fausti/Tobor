package world.entities.core;

import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Sand extends Object {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_SAND_0")),
			new Sprite(Tobor.Tileset.find("SPR_SAND_1")),
			new Sprite(Tobor.Tileset.find("SPR_SAND_2")),
			new Sprite(Tobor.Tileset.find("SPR_SAND_3")),
			new Sprite(Tobor.Tileset.find("SPR_SAND_4")),
		];
		
		gfx = SPRITES[type];
	}
	
	override
	public function getFriction():Float {
		return 3.0;
	}
	
	override public function canEnter(e:Object):Bool {
		if (Std.is(e, ObjectAI) || isPlayer(e)) return true;
		return false;
	}
}