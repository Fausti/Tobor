package world.entities.std;

import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Stairs extends EntityStatic {
	static var SPR_STAIRS_UP:Sprite;
	static var SPR_STAIRS_DOWN:Sprite;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function initSprites() {
		if (SPR_STAIRS_UP == null) {
			SPR_STAIRS_UP = Gfx.getSprite(224, 108);
		}
		
		if (SPR_STAIRS_DOWN == null) {
			SPR_STAIRS_DOWN = Gfx.getSprite(240, 108);
		}
	}
	
	override public function init() {
		super.init();
		initSprites();
	}
	
	override public function render() {
		switch(type) {
			case 0:
				setSprite(SPR_STAIRS_UP);
			case 1:
				setSprite(SPR_STAIRS_DOWN);
		}
		
		super.render();
	}

	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) return true;
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie)) {
			if (!e.visible) return;
			
			switch(type) {
				case 0:
					getWorld().stairsFrom(this);
				case 1:
					getWorld().stairsFrom(this);
			}
		}
	}
}