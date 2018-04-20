package world.entities.std;

import world.entities.interfaces.IContainer;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Dealer extends NPC implements IContainer {

	public function new() {
		super();
		
		SPR_NPC_0 = Gfx.getSprite(64, 276);
		SPR_NPC_1 = Gfx.getSprite(64 + 16, 276);
		
		SPR_NPC_LAYER_0 = Gfx.getSprite(64 + 32, 276);
		SPR_NPC_LAYER_1 = Gfx.getSprite(64 + 48, 276);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!e.alive) return;
		if (!e.visible) return;
		if (!Std.is(e, Charlie)) return;
		
		if (timeLeft == 0.0) {
			if (content != null) {
				var unpacked:Entity = getFactory().create(content);
			
				if (unpacked != null) {
					room.spawnEntity(gridX, gridY, unpacked);
				}
				
				content = null;
			}
			
			timeLeft = waitTime;
		}
	}
	
	override public function render_editor() {
		super.render_editor();
		
		if (getWorld().game.blink) {
			if (content != "" && content != null) {
				var template = getFactory().findFromID(content);
			
				if (template != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, template.spr);
			}
		}
	}
}