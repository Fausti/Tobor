package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class BedrockPath extends EntityFloor {
	var SPR_BEDROCK_PATH:Sprite;
	
	public function new() {
		super();
		
		SPR_BEDROCK_PATH = Gfx.getSprite(240, 180);
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_BEDROCK_PATH);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.isOfType(e, EntityAI)) return true;
		
		if (Std.isOfType(e, Charlie)) return true;
		
		if (Std.isOfType(e, EntityCollectable)) return true;
		
		return false;
	}
}