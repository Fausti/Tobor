package world.entities.core;

import gfx.Sprite;
import lime.math.Rectangle;
import world.entities.Message;
import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Arrow extends Object {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_0")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_1")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_2")),
			new Sprite(Tobor.Tileset.find("SPR_PFEIL_3"))
		];
		
		updateSprite();
		
		isStatic = false;
	}
	
	function updateSprite() {
		gfx = SPRITES[type];
		changed = true;
	}
	
	override public function canEnter(e:Object):Bool {
		if (isPlayer(e)) {
			if (e.gridX < gridX && type == 1) {
				return true;
			} else if (e.gridX > gridX && type == 3) {
				return true;
			} else if (e.gridY < gridY && type == 2) {
				return true;
			} else if (e.gridY > gridY && type == 0) {
				return true;
			}
		}
		
		return false;
	}
	
	function rotate(value:Int) {
		if (value < 4) {
			type += value;
			
			while (type >= 4) {
				type -= 4;
			}
			
			while (type <= -1) {
				type += 4;
			}
		}
	}
	
	override public function onMessage(msg:Message) {
		switch(msg.msg) {
			case "MAGNET_DROP":
				var dx:Int = gridX - msg.sender.gridX;
				var dy:Int = gridY - msg.sender.gridY;
				
				if (msg.sender.type == 0) {
					if (dx != 0 && dy == 0) {
						if (dx < 0) {
							type = 3;
						} else if (dx > 0) {
							type = 1;
						}
					} else if (dx == 0 && dy != 0) {
						if (dy < 0) {
							type = 0;
						} else if (dy > 0) {
							type = 2;
						}
					}
				} else {
					if (dx != 0 && dy == 0) {
						if (dx < 0) {
							type = 1;
						} else if (dx > 0) {
							type = 3;
						}
					} else if (dx == 0 && dy != 0) {
						if (dy < 0) {
							type = 2;
						} else if (dy > 0) {
							type = 0;
						}
					}
				}
				
				updateSprite();
			case "MAGNET_PICKUP":
				var dx:Int = gridX - msg.sender.gridX;
				var dy:Int = gridY - msg.sender.gridY;
				
				if ((dx != 0 && dy == 0) || (dx != 0 && dy == 0)) {
					if (msg.sender.type == 0) {
						rotate(1);
					} else {
						rotate(-1);
					}
				
					updateSprite();
				}
			default:
				
		}
	}
}