package world.entities.std;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Wood extends EntityFloor {
	public static var SPR_WOOD:Array<Sprite> = Gfx.getSprites(null, 0, 252, 0, 8);
	
	public function new() {
		super();
	}

	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WOOD[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}