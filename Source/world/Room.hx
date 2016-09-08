package world;
import world.entity.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var SIZE_X:Int = 40;
	public static inline var SIZE_Y:Int = 28;
	
	public var worldX:Int;
	public var worldY:Int;
	public var worldZ:Int;
	
	public var entities:Array<Entity>;
	public var redraw:Bool = true;
	
	public var collisions:Array<Entity> = [];
	
	public function new(x:Int, y:Int, level:Int) {
		this.worldX = x;
		this.worldY = y;
		this.worldZ = level;
		
		entities = [];
	}
	
	public function update(deltaTime:Float):Bool {
		for (e in entities) {
			e.update(deltaTime);
			
			if (e.isStatic && e.changed) redraw = true;
		}

		return redraw;
	}
	
	public function draw(layer:Int) {
		for (e in entities) {
			switch(layer) {
				case Room.LAYER_BACKGROUND:
					if (e.isStatic) e.draw();
				case Room.LAYER_SPRITE:
					if (!e.isStatic) e.draw();
				default:
			}
		}
		
		redraw = false;
	}
	
	public function outOfRoom(x:Int, y:Int):Bool {
		return (x < 0 || y < 0 || x >= 40 || y >= 28);
	}
	
	public function add(e:Entity, ?checkCollision:Bool = false) {
		if (entities.indexOf(e) >= 0) {
			trace(entities.indexOf(e));
		} else {
			if (checkCollision) {
				if (getEntitiesAt(e.gridX, e.gridY).length > 0) return;
			}
			
			e.room = this;
			entities.push(e);
			
			if (e.isStatic) {
				redraw = true;
			}
		}
	}
	
	public function remove(e:Entity) {
		entities.remove(e);
		
		if (e.isStatic) redraw = true;
	}
	
	public function getEntitiesAt(x:Int, y:Int, ?enteringEntity:Entity = null):Array<Entity> {
		collisions = [];
		
		for (e in entities) {
			if (e.gridX == x && e.gridY == y) {
				if (enteringEntity == null) collisions.push(e);
				else if (enteringEntity != e) collisions.push(e);
			}
		}
		
		return collisions;
	}
	
	public static inline var LAYER_BACKGROUND:Int = 0;
	public static inline var LAYER_SPRITE:Int = 1;
}