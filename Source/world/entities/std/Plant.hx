package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Plant extends EntityStatic {
	public static var SPR_PLANT = Gfx.getSprite(96, 312);
	
	public function new() {
		super();
		
		setSprite(SPR_PLANT);
	}

	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) {
			if (getInventory().hasItem("OBJ_SICKLE")) return true;
		}
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (getInventory().hasItem("OBJ_SICKLE")) {
				if (Utils.chance(25)) spawnPlants();
				die();
			}
		}
	}
	
	function spawnPlants() {
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
}