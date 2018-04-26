package world.entities.std;

import lime.math.Vector2;
import world.ObjectFactory.ObjectTemplate;
import world.entities.Entity;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class Water extends EntityFloor implements IElectric {
	public static var SPR_WATER:Array<Sprite> = [
		Gfx.getSprite(0, 72), // shallow
		Gfx.getSprite(16, 72), // deep
			
		Gfx.getSprite(80, 72), // nw
		Gfx.getSprite(96, 72), // sw
		Gfx.getSprite(112, 72), // ne
		Gfx.getSprite(128, 72) // se
	];
	
	static var FULL_TILES = [0, 1];
	static var HALF_TILES = [
		Direction.NW => [2],
		Direction.SW => [3],
		Direction.NE => [4],
		Direction.SE => [5]
	];
	
	public function new() {
		super();
		
		fullTiles = FULL_TILES;
		halfTiles = HALF_TILES;
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
	
	override public function render() {
		// Untergrund zeichnen?
		if (isHalfTile()) {
			renderSubType();
		}
		
		// Wassergrafik zeichnen
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WATER[type]);
	}
	
	override public function render_editor() {
		super.render_editor();
		
		if (drift > -1 && drift < 8) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, Drift.getSprite(drift));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (isHalfTile()) {
			if (subType > 0) {
				return canEnterSubType(e, direction, speed);
			}
		}
		
		if (Std.is(e, Shark)) return true;
		if (Std.is(e, Charlie)) return true;
		
		if (type == 0 || type == 1) {
			if (Std.is(e, EntityPushable)) return true;
		}
		
		if (Std.is(e, Bullet)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		// Wasser reagiert nur auf Charlie wenn er sichtbar ist!
		if (Std.is(e, Charlie) && e.visible) {
			if (getInventory().hasItem("OBJ_BUCKET#0")) {
				
				var count:Int = getInventory().getCount("OBJ_BUCKET#0");
				getInventory().remove("OBJ_BUCKET#0", count);
				
				var tmpl:ObjectTemplate = getFactory().findFromID("OBJ_BUCKET#1");
				if (tmpl != null) getInventory().add("OBJ_BUCKET#1", tmpl.spr, count);
			}
			
			// "Wasserwandeln"
			if (getWorld().checkRingEffect(1)) return;
			
			var c:Charlie = cast e;
			
			var canMove:Bool = false;
			
			// 90% Chance das man mit Schwimmflossen in die gewünschte Richtung schwimmt
			if (Utils.chance(90)) {
				if (room.getInventory().hasItem("OBJ_FLIPPERS")) {
					var d:Vector2 = Direction.NONE;
					
					if (Input.isKeyDown(Tobor.KEY_LEFT)) {
						d = Direction.W;
					} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
						d = Direction.E;
					} else if (Input.isKeyDown(Tobor.KEY_UP)) {
						d = Direction.N;
					} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
						d = Direction.S;
					}
					
					canMove = c.move(d, Charlie.PLAYER_SPEED / 2);
				}
			}
				
			if (!canMove) {
				// 75% Chance in die Richtung zu treiben in die man gerade geschwommen/getrieben ist
				if (Utils.chance(75)) {
					if (direction != null) canMove = c.move(direction, Charlie.PLAYER_SPEED / 2);
				}
			}
				
			if (!canMove) canMove = c.move(getDrift(0), Charlie.PLAYER_SPEED / 2);
				
			if (!canMove) canMove = c.move(getDrift(1), Charlie.PLAYER_SPEED / 2);
			if (!canMove) canMove = c.move(getDrift(2), Charlie.PLAYER_SPEED / 2);
			
			while (!canMove) {
				canMove = c.move(Direction.getRandom(), Charlie.PLAYER_SPEED / 2);
			}
		} else if (Std.is(e, EntityPushable)) {
			if (Std.is(e, Isolator)) {
				if (Std.is(e, SoftIsolator)) {
					e.die();
				} else {
					if (type == 0) {
						var waterIsolator:WaterIsolator = new WaterIsolator();
						room.spawnEntity(x, y, waterIsolator);
					
						die();
						e.die();
					} else {
						e.die();
					}	
				}
			} else {
				e.die();
			}
		}
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		if (Std.is(e, Charlie)) {
			if (room.getInventory().hasItem("OBJ_FLIPPERS")) {
				var c:Charlie = cast e;
				c.changeSpeed(Charlie.PLAYER_SPEED / 2);
			}
		}
	}
	
	override public function onLeave(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (room.getInventory().hasItem("OBJ_FLIPPERS")) {
				var c:Charlie = cast e;
				c.changeSpeed(Charlie.PLAYER_SPEED / 2);
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
	
	override public function canCombine(e:Entity, ?reverse:Bool = false):Bool {
		return checkCombine(e, reverse);
	}
	
	override public function doCombine(e:Entity, ?reverse:Bool = false) {
		combine(e, reverse);
	}
}