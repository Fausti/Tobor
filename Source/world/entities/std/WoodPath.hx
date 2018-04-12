package world.entities.std;

import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class WoodPath extends EntityFloor {
	var SPR_WOODPATH:Sprite;
	var SPR_WOODPATH_EDITOR:Sprite;
	
	public function new() {
		super();
		
		SPR_WOODPATH = Gfx.getSprite(112, 252);
		SPR_WOODPATH_EDITOR = Gfx.getSprite(160, 252);
	}
	
	override public function render() {
		if (getInventory().containsCompass) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WOODPATH_EDITOR);
		} else {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WOODPATH);
		}
	}
	
	override public function render_editor() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WOODPATH_EDITOR);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, EntityAI)) return true;
		
		if (Std.is(e, Charlie) && getInventory().hasItem("OBJ_SHOES")) return true;
		
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
}