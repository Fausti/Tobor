package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;
import world.entities.interfaces.IContainer;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Bagpack extends EntityItem implements IContainer {
	static var SPR_BAGPACK:Array<Sprite>;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	static function initSprites() {
		if (SPR_BAGPACK == null) {
			SPR_BAGPACK = [];
			for (i in 0 ... 5) {
				SPR_BAGPACK.push(Gfx.getSprite(128 + i * 16, 144));
			}
		}
	}
	
	override public function init() {
		super.init();
		initSprites();
		
		setSprite(SPR_BAGPACK[type]);
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
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie)) {
			if (!getInventory().hasItem(getID())) {
				onPickup();
				die();
			}
		}
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		if (item.content != null) {
			var unpacked:Entity = getFactory().create(item.content);
			
			if (unpacked != null) {
				room.spawnEntity(x, y, unpacked);
			}
		}
		
		removeFromInventory();
	}
}