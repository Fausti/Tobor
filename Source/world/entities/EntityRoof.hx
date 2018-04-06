package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class EntityRoof extends EntityStatic {
	static var COLOR_TRANSPARENT:Color = new Color(1, 1, 1, 0.25);
	
	public function new() {
		super();
		
		z = Room.LAYER_ROOF;
	}
	
	override public function init() {
		super.init();
		
		z = Room.LAYER_ROOF;
	}
	
	override public function render() {
		if (!room.underRoof) super.render();
	}
	
	override public function render_editor() {
		if (!room.underRoof) {
			super.render_editor();
		} else {
			for (spr in sprites) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr, COLOR_TRANSPARENT);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
}