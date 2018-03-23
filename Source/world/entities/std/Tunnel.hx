package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityMoveable;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Tunnel extends EntityStatic {

	public function new() {
		super();
	}
	
	override public function init() {
		super.init();
		
		switch(type) {
			case 0:
				setSprite(Gfx.getSprite(192, 72));
			case 1:
				setSprite(Gfx.getSprite(192 + 16, 72));
			case 2:
				setSprite(Gfx.getSprite(192 + 32, 72));
			case 3:
				setSprite(Gfx.getSprite(192 + 48, 72));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		var walkSpeed:Float = 4;
		
		if (!e.visible) {
			e.visible = true;
			return;
		}
		
		switch (type) {
			case 0:	// S
				if (direction == Direction.S) {
					var target:Entity = null;
					var dist:Int = 1000;
					
					for (t in room.findAll(Tunnel)) {
						if (t.type == 1) {
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
					
					if (target != null) {
						var ee:EntityMoveable = cast e;
						
						ee.move(Direction.S, walkSpeed, dist);
						ee.visible = false;
					}
				}
			case 1: // N
				if (direction == Direction.N) {
					var target:Entity = null;
					var dist:Int = 1000;
					
					for (t in room.findAll(Tunnel)) {
						if (t.type == 0) {
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
					
					if (target != null) {
						var ee:EntityMoveable = cast e;
						
						ee.move(Direction.N, walkSpeed, dist);
						ee.visible = false;
					}
				}
			case 2: // E
				if (direction == Direction.E) {
					var target:Entity = null;
					var dist:Int = 1000;
					
					for (t in room.findAll(Tunnel)) {
						
						if (t.type == 3) {
														
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
					
					if (target != null) {
						var ee:EntityMoveable = cast e;

						ee.move(Direction.E, walkSpeed, dist);
						ee.visible = false;
					}
				}
			case 3: // W
				if (direction == Direction.W) {
					var target:Entity = null;
					var dist:Int = 1000;
					
					for (t in room.findAll(Tunnel)) {
						if (t.type == 2) {
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
					
					if (target != null) {
						var ee:EntityMoveable = cast e;
						
						ee.move(Direction.W, walkSpeed, dist);
						ee.visible = false;
					}
				}
		}
	}
}