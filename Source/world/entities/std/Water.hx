package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class Water extends EntityStatic implements IElectric {
	var SPR_WATER:Array<Sprite>;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function getDrift(?phase:Int = 0):Vector2 {
		if (phase == 0) {
			switch (type) {
				case 2:
					return Direction.SE;
				case 3:
					return Direction.NE;
				case 4:
					return Direction.SW;
				case 5:
					return Direction.NW;
				default:
					if (drift == -1) {
						return Direction.getRandom();
					} else {
						return Direction.ALL[drift + 1];
					}
			}
		} else if (phase == 1) {
			switch (type) {
				case 2:
					return Direction.S;
				case 3:
					return Direction.N;
				case 4:
					return Direction.S;
				case 5:
					return Direction.N;
				default:
					if (drift == -1) {
						return Direction.getRandom();
					} else {
						return Direction.ALL[drift + 1];
					}
			}
		} else if (phase == 2) {
			switch (type) {
				case 2:
					return Direction.E;
				case 3:
					return Direction.E;
				case 4:
					return Direction.W;
				case 5:
					return Direction.W;
				default:
					if (drift == -1) {
						return Direction.getRandom();
					} else {
						return Direction.ALL[drift + 1];
					}
			}
		}
		
		return Direction.NONE;
	}
	
	function initSprites() {
		if (SPR_WATER == null) {
			SPR_WATER = [
				Gfx.getSprite(0, 72), // shallow
				Gfx.getSprite(16, 72), // deep
			
				Gfx.getSprite(80, 72), // nw
				Gfx.getSprite(96, 72), // sw
				Gfx.getSprite(112, 72), // ne
				Gfx.getSprite(128, 72) // se
			];
		}
		
		setSprite(SPR_WATER[type]);
	}
	
	override public function init() {
		super.init();
		
		initSprites();
	}
	
	override public function render_editor() {
		super.render_editor();
		
		if (drift > -1 && drift < 8) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, Drift.getSprite(drift));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return Std.is(e, Charlie);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			var c:Charlie = cast e;
			
			if (!room.getInventory().hasItem("OBJ_FLIPPERS")) {
				var canMove:Bool = c.move(getDrift(0), Charlie.PLAYER_SPEED / 3);
				
				if (!canMove) canMove = c.move(getDrift(1), Charlie.PLAYER_SPEED / 3);
				if (!canMove) canMove = c.move(getDrift(2), Charlie.PLAYER_SPEED / 3);
			
				while (!canMove) {
					canMove = c.move(Direction.getRandom(), Charlie.PLAYER_SPEED / 3);
				}
			}
		}
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie)) {
			if (room.getInventory().hasItem("OBJ_FLIPPERS")) {
				var c:Charlie = cast e;
				c.changeSpeed(Charlie.PLAYER_SPEED / 3);
			}
		}
	}
	
	override public function onLeave(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (room.getInventory().hasItem("OBJ_FLIPPERS")) {
				var c:Charlie = cast e;
				c.changeSpeed(Charlie.PLAYER_SPEED / 3);
			}
		}
	}

	override public function switchStatus() {
		super.switchStatus();
		
		if (drift != -1) {
			switch(drift) {
				case 0:
					drift = 1;
				case 1:
					drift = 0;
				case 2:
					drift = 3;
				case 3:
					drift = 2;
					
				case 4:
					drift = 7;
				case 5:
					drift = 6;
				case 6:
					drift = 5;
				case 7:
					drift = 4;
			}
		}
	}
}