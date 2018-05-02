package world.entities.std;

import lime.math.Vector2;
import world.entities.EntityFloor;

/**
 * ...
 * @author Matthias Faust
 */
class MountainPath extends EntityFloor {
	public static var SPR_MOUNTAINPATH:Sprite = Gfx.getSprite(160, 264);
	public static var SPR_MOUNTAINPATH_EDITOR:Sprite = Gfx.getSprite(144, 264);
	
	public function new() {
		super();
	}
	
	override public function render() {
		if (getInventory().containsCompass) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_MOUNTAINPATH_EDITOR);
		} else {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_MOUNTAINPATH);
		}
	}
	
	override public function render_editor() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_MOUNTAINPATH_EDITOR);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, EntityAI)) return true;
		
		if (Std.is(e, Charlie) && getInventory().hasItem("OBJ_SHOES")) return true;
		
		if (Std.is(e, EntityCollectable)) return true;
		
		return false;
	}
}