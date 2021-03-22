package world.entities.std;

import world.entities.EntityStatic;
import world.entities.interfaces.IContainer;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class TeleportEnd extends EntityStatic implements IContainer {
	static var SPR_TELEPORT_0:Sprite;
	static var SPR_TELEPORT_1:Sprite;
	
	static var SPR_TELEPORT_0_EDITOR:Sprite;
	static var SPR_TELEPORT_1_EDITOR:Sprite;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function initSprites() {
		if (SPR_TELEPORT_0 == null) {
			SPR_TELEPORT_0 = Gfx.getSprite(32, 312);
		}
		
		if (SPR_TELEPORT_1 == null) {
			SPR_TELEPORT_1 = Gfx.getSprite(80, 312);
		}
		
		if (SPR_TELEPORT_0_EDITOR == null) {
			SPR_TELEPORT_0_EDITOR = Gfx.getSprite(16, 312);
		}
		
		if (SPR_TELEPORT_1_EDITOR == null) {
			SPR_TELEPORT_1_EDITOR = Gfx.getSprite(64, 312);
		}
	}
	
	override public function init() {
		super.init();
		initSprites();
	}

	override public function render() {

	}
	
	override public function render_editor() {
		switch(type) {
			case 0:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_TELEPORT_0_EDITOR);
			case 1:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_TELEPORT_1_EDITOR);
		}
		
		if (getWorld().game.blink) {
			if (content != "" && content != null) {
				var template = getFactory().findFromID(content);
			
				if (template != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, template.spr);
			}
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) return true;
		
		return super.canEnter(e, direction, speed);
	}
}