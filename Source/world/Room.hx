package world;

import world.World;
import world.entities.Entity;
import world.entities.EntityDynamic;
import world.entities.EntityStatic;
import world.entities.std.Isolator;
import world.entities.std.Wall;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var WIDTH:Int = 40;
	public static inline var HEIGHT:Int = 28;
	
	public var world:World;
	
	private var listAll:Array<Entity> = [];
	
	private var listDynamic:Array<Entity> = [];
	private var listStatic:Array<Entity> = [];
	
	private var listRemove:Array<Entity> = [];
	
	public function new(w:World) {
		this.world = w;
		
		var e:Entity;
		
		for (i in 0 ... 500) {
			e = new Wall();
			e.setPosition(Std.random(WIDTH), Std.random(HEIGHT));
			
			addEntity(e);
		}
		
		for (i in 0 ... 500) {
			e = new Isolator();
			e.setPosition(Std.random(WIDTH), Std.random(HEIGHT));
			
			addEntity(e);
		}
	}
	
	public function update_begin(deltaTime:Float) {
		for (e in listDynamic) {
			e.update_begin(deltaTime);
		}
	}
	
	public function update_end(deltaTime:Float) {
		for (e in listDynamic) {
			e.update_end(deltaTime);
		}
	}
	
	public function render() {
		for (e in listAll) {
			e.render();
		}
	}
	
	public function addEntity(e:Entity) {
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		if (listAll.indexOf(e) == -1) {
			listAll.push(e);
		}
		
		var list:Array<Entity> = null;
		
		if (Std.is(e, EntityDynamic)) {
			list = listDynamic;
		} else if (Std.is(e, EntityStatic)) {
			list = listStatic;
		}
		
		if (list != null) {
			if (list.indexOf(e) == -1) {
				list.push(e);
			}
		}
		
		e.setRoom(this);
	}
	
	function removeEntity(e:Entity) {
		listAll.remove(e);
		listStatic.remove(e);
		listDynamic.remove(e);
	}
}