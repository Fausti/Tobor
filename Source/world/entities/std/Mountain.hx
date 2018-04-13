package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Mountain extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;

		var sprList:Array<Sprite> = [];
		
		for (i in 0 ... 4) {
			sprList.push(Gfx.getSprite(176 + i * 16, 264));
		}
		
		for (i in 0 ... 8) {
			sprList.push(Gfx.getSprite(128 + i * 16, 288));
		}
		
		for (i in 0 ... 8) {
			sprList.push(Gfx.getSprite(128 + i * 16, 300));
		}
		
		spr = sprList[type];
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		return false;
	}
}