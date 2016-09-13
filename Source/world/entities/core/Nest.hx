package world.entities.core;

import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Nest extends Object {
	var SPRITES:Array<Sprite>;
	
	var playerSide:Int = 0;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_NEST_0")),
			new Sprite(Tobor.Tileset.find("SPR_NEST_1")),
			new Sprite(Tobor.Tileset.find("SPR_NEST_2"))
		];
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		var p = room.world.player;
		
		var dist:Float = Math.abs(gridX - p.gridX) + Math.abs(gridY - p.gridY);
		
		if (dist <= 3) {
			if (p.gridX < gridX) {
				playerSide = 1;
			} else if (p.gridX > gridX) {
				playerSide = 2;
			}
		} else {
			playerSide = 0;
		}
		
		gfx = SPRITES[playerSide];
		changed = true;
	}
}