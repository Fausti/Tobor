package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;
import world.entities.interfaces.IContainer;

/**
 * ...
 * @author Matthias Faust
 */
class TeleportStart extends EntityStatic implements IContainer {
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
			SPR_TELEPORT_0_EDITOR = Gfx.getSprite(0, 312);
		}
		
		if (SPR_TELEPORT_1_EDITOR == null) {
			SPR_TELEPORT_1_EDITOR = Gfx.getSprite(48, 312);
		}
	}
	
	override public function init() {
		super.init();
		initSprites();
	}

	override public function render() {
		// leere Teleporter NICHT zeichnen!
		if (content == null) return;
		
		switch(type) {
			case 0:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_TELEPORT_0);
			case 1:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_TELEPORT_1);
		}
		
		if (content != "" && content != null) {
				var template = getFactory().findFromID(content);
			
				if (template != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, template.spr);
			}
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
		if (Std.is(e, Charlie)) {
			if (content != null) {
				switch(type) {
					case 0:
						if (!getInventory().hasItem(content)) return true; else return false;
					case 1:
						if (getInventory().hasItem(content)) return true; else return false;
				}
			}
			
			return true;
		}
		
		if (Std.is(e, EntityAI)) return true;
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			
			if (content == null) {
				getWorld().teleportFrom(this);
			} else {
				switch(type) {
					case 0:
						if (!getInventory().hasItem(content)) getWorld().teleportFrom(this);
					case 1:
						if (getInventory().hasItem(content)) getWorld().teleportFrom(this);
				}
			}
		}
	}
}