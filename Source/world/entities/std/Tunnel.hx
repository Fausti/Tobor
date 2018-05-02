package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Tunnel extends EntityFloor {
	public static var SPR_TUNNEL:Array<Sprite> = Gfx.getSprites([], 192, 72, 0, 4);
	
	public function new() {
		super();
	}

	override public function render() {
		if (subType > 0) {
			renderSubType();
		}
		
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_TUNNEL[type]);
	}
	
	override function canCombine(e:Entity, ?reverse:Bool = false):Bool {
		trace("combine with tunnel", e);
		
		var cl = Type.getClass(this);
		var sameClass = Std.is(e, cl);
		
		if (sameClass) return false;
		
		if (!sameClass && Std.is(e, Sand)) {
			return true;
		} else if (!sameClass && Std.is(e, Grass)) {
			return true;
		} else if (!sameClass && Std.is(e, Path)) {
			return true;
		} else if (!sameClass && Std.is(e, Water)) {
			return true;
		}
		
		return false;
	}
	
	override function doCombine(e:Entity, ?reverse:Bool = false) {
		var cl = Type.getClass(this);
		var sameClass = Std.is(e, cl);
		
		var newType:Int = -1;
		var newSubType:Int = -1;
		
		if (sameClass) return;
		
		if (!sameClass && Std.is(e, Water)) {
			switch(e.type) {
				case 0:
					newSubType = 16;
				case 1:
					newSubType = 17;
			}
		} else if (!sameClass && Std.is(e, Sand)) {
			newSubType = 1;
		} else if (!sameClass && Std.is(e, Grass)) {
			newSubType = 5;
		} else if (!sameClass && Std.is(e, Path)) {
			newSubType = 10;
		}
		
		// trace("old: ", this, type, subType, e, e.type, e.subType);
		
		if (subType == 0) {
			if (subType != newSubType && newSubType > -1) subType = newSubType;
		}
		
		// trace("new: ", this, type, subType, e, e.type, e.subType);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!Std.is(e, Charlie)) return;
		
		var walkSpeed:Float = 4;
		
		if (!e.visible) {
			e.visible = true;
			return;
		}
		
		var target:Entity = null;
		var dist:Int = 1000;
		
		switch (type) {
			case 0:	// S
				if (direction == Direction.S) {
					for (t in room.findAll(Tunnel)) {
						if (t.type == 1 && t.x == this.x && t.y > this.y) {
							if (target == null) {
								dist = Std.int(Math.abs(y - t.y));
								target = t;
							}
							else {
								var dist2:Int = Std.int(Math.abs(y - t.y));
								if (dist2 < dist) {
									dist = dist2;
									target = t;
								}
							}
						}
					}
				}
			case 1: // N
				if (direction == Direction.N) {
					for (t in room.findAll(Tunnel)) {
						if (t.type == 0 && t.x == this.x && t.y < this.y) {
							if (target == null) {
								dist = Std.int(Math.abs(y - t.y));
								target = t;
							}
							else {
								var dist2:Int = Std.int(Math.abs(y - t.y));
								if (dist2 < dist) {
									dist = dist2;
									target = t;
								}
							}
						}
					}
				}
			case 2: // E
				if (direction == Direction.E) {
					for (t in room.findAll(Tunnel)) {
						
						if (t.type == 3 && t.y == this.y && t.x > this.x) {
														
							if (target == null) {
								dist = Std.int(Math.abs(x - t.x));
								target = t;
							}
							else {
								var dist2:Int = Std.int(Math.abs(x - t.x));
								if (dist2 < dist) {
									dist = dist2;
									target = t;
								}
							}
						}
					}
				}
			case 3: // W
				if (direction == Direction.W) {
					for (t in room.findAll(Tunnel)) {
						if (t.type == 2 && t.y == this.y && t.x < this.x) {
							if (target == null) {
								dist = Std.int(Math.abs(x - t.x));
								target = t;
							}
							else {
								var dist2:Int = Std.int(Math.abs(x - t.x));
								if (dist2 < dist) {
									dist = dist2;
									target = t;
								}
							}
						}
					}
				}
		}
		
		if (target != null) {
			var ee:EntityMoveable = cast e;
						
			ee.move(direction, walkSpeed, dist);
			ee.visible = false;
		}
	}
}