package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityAI;

/**
 * ...
 * @author Matthias Faust
 */
class Robot extends EntityAI {
	public function new() {
		super();
	
		type = Std.random(7);
		
		var c0:Color = Color.palette[Std.random(Color.palette.length - 1)];
		var c1:Color = Color.palette[Std.random(Color.palette.length - 1)];
		var c2:Color = Color.palette[Std.random(Color.palette.length - 1)];
		
		var mx:Int = 32 * type;
		
		sprites[0] = new Animation([
			Gfx.getSprite(mx + 0, 84),
			Gfx.getSprite(mx + 16, 84)
		], 0.75);
		
		sprites[1] = new Animation([
			Gfx.getSprite(mx + 0, 96),
			Gfx.getSprite(mx + 16, 96)
		], 0.75);
		
		sprites[2] = new Animation([
			Gfx.getSprite(mx + 0, 108),
			Gfx.getSprite(mx + 16, 108)
		], 0.75);
		
		sprites[0].color = c0;
		cast(sprites[0], Animation).start();
		sprites[1].color = c1;
		cast(sprites[1], Animation).start();
		sprites[2].color = c2;
		cast(sprites[2], Animation).start();
	}
	
	override function idle() {
		move(Direction.ALL[Std.random(Direction.ALL.length)], 2);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
	
	override function onStartMoving() {
		Sound.play(Sound.SND_ROBOT_STEP);
	}
	
	override function onStopMoving() {
		// wait = Math.random() / 4;
	}
}