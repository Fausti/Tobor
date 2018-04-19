package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;
import world.entities.interfaces.IContainer;

/**
 * ...
 * @author Matthias Faust
 */
class Spot extends EntityStatic implements IContainer {
	var SPR_X:Sprite;
	
	public function new() {
		super();
		
		SPR_X = Gfx.getSprite(224, 84);
	}
	
	override public function render() {
		
	}
	
	override public function render_editor() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_X);
		
		if (getWorld().game.blink) {
			if (content != "" && content != null) {
				var template = getFactory().findFromID(content);
			
				if (template != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, template.spr);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
}