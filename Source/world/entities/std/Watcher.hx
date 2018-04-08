package world.entities.std;

import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class Watcher extends EntityDynamic {
	var SPR_WATCHERS:Array<Sprite> = [];
	var timer:Float = 0;
	
	public function new() {
		super();
		
		z = Room.LAYER_OVERLAY;
		
		for (i in 0 ... 3) {
			SPR_WATCHERS.push(Gfx.getSprite(80 + i * 16, 60));
		}
		
		setSprite(SPR_WATCHERS[0]);
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		timer = timer - deltaTime;
		
		if (timer <= 0.5) {
			var player:Charlie = getPlayer();
			var distToPlayer:Float = Utils.distance(x, y, player.x, player.y);
			
			if (room.getAllEntitiesAt(x, y, this).length == 0) {
				if (distToPlayer <= 4.0) {
					visible = true;
				} else {
					visible = false;
				}
			}
			
			if (distToPlayer <= 1.5) {
				var robot:Robot = new Robot();
				robot.init();
			
				room.spawnEntity(x, y, robot);
			
				die();
			}
		}
		
		if (timer <= 0.0) {
			timer = 1.0;
			
			setSprite(SPR_WATCHERS[Std.random(3)]);
		}
	}
	
	override public function render() {
		super.render();
	}
	
}