package world.entities.std;

import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class WaterDeadly extends EntityDynamic {
	var ANIM_WATER:Animation;
	public static var SPR_WATER:Sprite = Gfx.getSprite(48, 72);
	
	public function new() {
		super();
		
		initSprites();
		
		z = Room.LAYER_FLOOR;
	}
	
	function initSprites() {
		var arr:Array<Sprite> = [];
		
		for (i in 0 ... Std.random(4) + 1) {
			arr.push(Gfx.getSprite(16, 72));
		}
		
		arr.push(Gfx.getSprite(32, 72));
		arr.push(Gfx.getSprite(48, 72));
		arr.push(Gfx.getSprite(64, 72));
				
		
		if (ANIM_WATER == null) {
			ANIM_WATER = new Animation(arr, 2.0 + Math.random() * 2);
		
			ANIM_WATER.onAnimationEnd = function () {
				ANIM_WATER.start(true);
			}
		
			ANIM_WATER.start(true);
		}
		
		setSprite(ANIM_WATER);
	}
	
	override public function init() {
		super.init();
		
		initSprites();
	}
	
	override public function render_editor() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WATER);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Shark)) return true;
		
		return Std.isOfType(e, Charlie);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie) && e.visible) {
			// "Wasserwandeln"
			if (getWorld().checkRingEffect(1)) return;
			
			if (!getWorld().checkFirstUse("DIED_BY_WATER")) {
				getWorld().markFirstUse("DIED_BY_WATER");
				getWorld().showPickupMessage("DIED_BY_WATER", false, function () {
					getWorld().hideDialog();
				});
			}
			
			e.die();
		}
	}
}