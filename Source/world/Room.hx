package world;

import world.entities.Message;
import world.entities.Object;
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
	
	public var entities:Array<Object>;
	public var redraw:Bool = true;
	
	public var collisions:Array<Object> = [];
	
	public function new(world:World, x:Int, y:Int, level:Int) {
		this.world = world;
		
		this.worldX = x;
		this.worldY = y;
		this.worldZ = level;
		
		entities = [];
	}
	
	/*
	public function copy():Room {
		var newRoom:Room = new Room(world, worldX, worldY, worldZ);
		
		for (e in entities) {
			newRoom.entities.push(e);
		}
	}
	*/
	
	public function update(deltaTime:Float):Bool {
		if (Tobor.GAME_MODE == GameMode.Play) {
			for (e in entities) {
				e.update(deltaTime);
			
				if (e.isStatic && e.changed) redraw = true;
			}
		}
		
		return redraw;
	}
	
	public function draw(layer:Int) {
		for (e in entities) {
			switch(layer) {
				case Room.LAYER_BACKGROUND:
					if (e.isStatic) {
						if (Tobor.GAME_MODE == GameMode.Edit) {
							e.editor_draw();
						} else {
							e.draw();
						}
					}
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
	
	public function add(e:Object, ?checkCollision:Bool = false) {
		if (entities.indexOf(e) >= 0) {
			// trace(entities.indexOf(e));
		} else {
			if (checkCollision) {
				if (getEntitiesAt(e.gridX, e.gridY).length > 0) return;
			}
			
			e.room = this;
			entities.push(e);
			
			e.onCreate();
			
			if (e.isStatic) {
				redraw = true;
			}
		}
	}
	
	public function remove(e:Object) {
		entities.remove(e);
		
		if (e.isStatic) redraw = true;
	}
	
	public function sendMessage(msg:Message, ?around:Bool = true) {
		if (around) {
			for (o in getEntitiesAround(msg.sender.gridX, msg.sender.gridY)) {
				o.onMessage(msg);
			}
		} else {
			for (o in entities) {
				o.onMessage(msg);
			}
		}
	}
	
	public function getEntitiesAround(x:Int, y:Int):Array<Object> {
		collisions = [];
		
		for (e in entities) {
			if (e.gridX >= x - 1 && e.gridX <= x + 1 && e.gridY >= y - 1 && e.gridY <= y + 1) {
				if (!(e.gridX == x && e.gridY == y)) {
					collisions.push(e);
				}
			}
		}
		
		return collisions;
	}
	
	public function getEntitiesAt(x:Int, y:Int, ?enteringEntity:Object = null):Array<Object> {
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
			// Debug.log(this, o);
			
			var entity:Object = EntityFactory.createFromID(o.get("id"), o.get("type"));
			if (entity != null) {
				for (key in Reflect.fields(o)) {
					entity.parseData(key, Reflect.field(o, key));
				}
			
				if (!Std.is(entity, Charlie)) {
					add(entity);
				}
			}
		}
		
		add(world.player);
	}
	
	public function save():Array<Map<String, Dynamic>> {
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in entities) {
			if (e != null) {
				if (!Std.is(e, Charlie)) {
					if (e.canSave()) {
						data.push(e.saveData());
					}
				}
			}
		}
		
		return data;
	}
	
	public static inline var LAYER_BACKGROUND:Int = 0;
	public static inline var LAYER_SPRITE:Int = 1;
}