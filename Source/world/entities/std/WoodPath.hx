package world.entities.std;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class WoodPath extends EntityFloor {
	public static var SPR_WOODPATH:Sprite = Gfx.getSprite(112, 252);
	public static var SPR_WOODPATH_EDITOR:Sprite = Gfx.getSprite(160, 252);
	
	public function new() {
		super();
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