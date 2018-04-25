package world.entities.std;

import world.entities.EntityDynamic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class PlantGrowing extends EntityDynamic {
	public static var SPR_PLANT_GROWING:Array<Sprite> = [
		Gfx.getSprite(112, 312), 		// W - 0
		Gfx.getSprite(112 + 64, 312),	// W - 1
		Gfx.getSprite(96, 312), 
		Gfx.getSprite(112 + 16, 312),	// N - 0
		Gfx.getSprite(112 + 80, 312),	// N - 1
		Gfx.getSprite(96, 312),
		Gfx.getSprite(112 + 32, 312),	// E - 0
		Gfx.getSprite(112 + 96, 312),	// E - 1
		Gfx.getSprite(96, 312),
		Gfx.getSprite(112 + 48, 312),	// S - 0
		Gfx.getSprite(112 + 112, 312),	// S - 1
		Gfx.getSprite(96, 312),
	];
	
	var timeLeft:Float;
	var growSpeed:Float = 2;
	
	public function new() {
		super();
		timeLeft = growSpeed - Config.getSpeed(1);
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_PLANT_GROWING[type]);
	}
	
	override public function update(deltaTime:Float) {
		timeLeft = timeLeft - deltaTime;
		if (timeLeft <= 0) {
			timeLeft = growSpeed - Config.getSpeed(1);
				
			switch(type) {
				case 0:
					type = 1;
				case 1:
					type = 2;
				case 2:
					spawnPlants();
					die();
					
				case 3:
					type = 4;
				case 4:
					type = 5;
				case 5:
					spawnPlants();
					die();
					
				case 6:
					type = 7;
				case 7:
					type = 8;
				case 8:
					spawnPlants();
					die();
					
				case 9:
					type = 10;
				case 10:
					type = 11;
				case 11:
					spawnPlants();
					die();
					
				default:
					// warum auch immer... hier war halt Platz xD
					die();
			}
		}
	}
	
	function spawnPlants() {
		var plant:Plant = new Plant();
		room.spawnEntity(x, y, plant);
		
		var places:Array<Vector2> = [];
		if (x > 0 && room.getAllEntitiesAt(x - 1, y).length == 0) places.push(Direction.W);
		if (x < (Room.WIDTH - 1) && room.getAllEntitiesAt(x + 1, y).length == 0) places.push(Direction.E);
		if (y > 0 && room.getAllEntitiesAt(x, y - 1).length == 0) places.push(Direction.N);
		if (y < (Room.HEIGHT - 1) && room.getAllEntitiesAt(x, y + 1).length == 0) places.push(Direction.S);
		
		if (places.length == 1) {
			spawnPlant(places[0]);
		} else if (places.length > 1) {
			var index:Int = Std.random(places.length);
			spawnPlant(places[index]);
			places.remove(places[index]);
			
			index = Std.random(places.length);
			spawnPlant(places[index]);
		}
	}
	
	function spawnPlant(d:Vector2) {
		var e:PlantGrowing = new PlantGrowing();
		
		if (d == Direction.W) {
			e.type = 0;
		} else if (d == Direction.N) {
			e.type = 3;
		} else if (d == Direction.E) {
			e.type = 6;
		} else if (d == Direction.S) {
			e.type = 9;
		} else {
			return;
		}
		
		room.spawnEntity(x + d.x, y + d.y, e);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) {
			if (getInventory().hasItem("OBJ_SICKLE")) return true;
		}
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (getInventory().hasItem("OBJ_SICKLE")) die();
		}
	}
	
}