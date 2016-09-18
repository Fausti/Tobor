package world.entities.core;

import gfx.Animation;
import gfx.Gfx;
import lime.math.Rectangle;
import lime.math.Vector2;
import world.Room;
import world.entities.Inventory;
/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends ObjectMoveable {
	
	public var lives:Int = 3;
	public var points:Int = 0;
	public var gold:Int = 0;
	
	public var inventory:Inventory;
	
	// Animation
	var animWalking:Animation;
	var animDeath:Animation;
	
	public function new() {
		super();
		
		speed = 1 / 4;
		
		// Stand- / Gehanimation
		
		animWalking = new Animation();
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_0"));
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_1"));
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_2"));
		
		animWalking.setSpeed(speed);
		
		// "Explositions"animation
		
		animDeath = new Animation();
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_0"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_1"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_2"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_3"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_4"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_5"));
		
		animDeath.setSpeed(5);
		
		// aktuelle Animation setzen
		
		gfx = animWalking;
		
		inventory = new Inventory();
	}
	
	override public function reset() {
		super.reset();
		
		inventory.clear();
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (!isAlive) {
			if (!animDeath.active) {
				isAlive = true;
				
				gfx = animWalking;
			}
		}
	}
	
	override
	public function die() {
		lives--;
		
		trace("ENTITY SNAP TO GRID ON DEATH! FOR ANIMATION!");
		
		if (!isMoving) {
			trace("---");
			isAlive = false;
			
			gfx = animDeath;
			animDeath.start();
		}
	}
	
	override
	public function move(dirX:Int, dirY:Int) {
		if (!isAlive) return;
		if (isMoving) return;
		if (dirX == 0 && dirY == 0) return;
		
		var canMove:Bool = true;
		
		friction = 1.0;
		
		
		if (room.outOfRoom(gridX + dirX, gridY + dirY)) {
			var rX:Int = room.worldX;
			var rY:Int = room.worldY;
			var rZ:Int = room.worldZ;
			
			if (dirX > 0) {
				rX++;
			} else if (dirX < 0) {
				rX--;
			} else if (dirY > 0) {
				rY++;
			} else if (dirY < 0) {
				rY--;
			}
			
			if (rX < 0 || rX > 9 || rY < 0 || rY > 9) {
				canMove = false;
			}
			
			var nextRoom:Room = room.world.findRoom(rX, rY, rZ);
			
			if (nextRoom == null) {
				canMove = false;
			}
		} else {
			/*
			for (e in room.getEntitiesAt(gridX, gridY, this)) {
				friction = Math.max(friction, e.getFriction());
			}
			*/
			
			for (e in room.getEntitiesAt(gridX + dirX, gridY + dirY, this)) {
				if (!e.canEnter(this)) canMove = false;
				friction = Math.max(friction, e.getFriction());
			}
		}
		
		if (canMove) {
			direction.x = dirX;
			direction.y = dirY;
			
			timeLeft = getMovingSpeed();
			
			onStartMoving();
		}
	}
	
	override
	function onStartMoving() {
		animWalking.setSpeed(getMovingSpeed());
		animWalking.start();
	}
	
	override
	function onStopMoving() {
		animWalking.stop();
		
		if (room.outOfRoom(gridX, gridY)) {
			var rX:Int = room.worldX;
			var rY:Int = room.worldY;
			var rZ:Int = room.worldZ;
			
			if (gridX > 39) {
				rX++;
			} else if (gridX < 0) {
				rX--;
			} else if (gridY > 27) {
				rY++;
			} else if (gridY < 0) {
				rY--;
			}
			
			/*
			if (rX < 0 || rX > 9 || rY < 0 || rY > 9) {
				canMove = false;
			}
			*/
			
			var nextRoom:Room = room.world.findRoom(rX, rY, rZ);
		
			if (gridX < 0) {
				gridX = 39;
			} else if (gridX > 39) {
				gridX = 0;
			} else if (gridY < 0) {
				gridY = 27;
			} else if (gridY > 27) {
				gridY = 0;
			}
			
			if (nextRoom != null) {
				room.world.switchRoom(nextRoom);
			}
		}
	}
	
	/*
	override
	public function draw() {
		// Gfx.drawTexture(x, y, 16, 12, anim.getUV());
	}
	*/
	
	
	// Savegame
	
	override 
	public function saveData():Map<String, Dynamic> {
		var out = super.saveData();
		
		out.set("lives", lives);
		out.set("gold", gold);
		out.set("points", points);
		
		out.set("inventory", inventory.save());
		
		return out;
	}
	
	override
	public function parseData(key:String, value:Dynamic) {
		if (value == null) return;
		
		switch(key) {
			case "gold":
				gold = value;
			case "lives":
				lives = value;
			case "points":
				points = value;
			case "inventory":
				inventory.load(value);
			default:
				super.parseData(key, value);
		}
	}
}