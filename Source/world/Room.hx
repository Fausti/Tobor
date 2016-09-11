package world;

import world.entities.Entity;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var SIZE_X:Int = 40;
	public static inline var SIZE_Y:Int = 28;
	
	public var world:world.World;
	public var worldX:Int;
	public var worldY:Int;
	public var worldZ:Int;
	
	public var entities:Array<Entity>;
	public var redraw:Bool = true;
	
	public var collisions:Array<Entity> = [];
	
	public function new(world:World, x:Int, y:Int, level:Int) {
		this.world = world;
		
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
	
	public function clear() {
		entities = [];
		
		redraw = true;
	}
	
	public function load(data:Array<Map<String, Dynamic>>) {
		clear();
		
		for (o in data) {
			trace(o);
			
			var entity:Entity = EntityFactory.createFromID(o.get("id"), o.get("type"));
			
			if (!Std.is(entity, Charlie)) {
				entity.gridX = o.get("x");
				entity.gridY = o.get("y");
			
				add(entity);
			}
		}
		
		add(world.player);
	}
	
	public function save():Array<Map<String, Dynamic>> {
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in entities) {
			if (e != null) {
				if (!Std.is(e, Charlie)) {
					data.push(e.save());
				}
			}
		}
		
		return data;
	}
	
	public static inline var LAYER_BACKGROUND:Int = 0;
	public static inline var LAYER_SPRITE:Int = 1;
}