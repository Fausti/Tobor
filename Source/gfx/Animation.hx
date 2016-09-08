package gfx;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Animation implements IDrawable {
	var frames:Array<Rectangle> = [];
	var sequence:Array<Int> = [];
	
	var index:Int = 0;
	
	var speed:Float = 1;
	var timeLeft:Float = 0;
	
	public var active:Bool = false;
	
	public function new() {
	
	}
	
	public function update(deltaTime:Float) {
		if (!active) return;
		
		if (timeLeft < deltaTime) timeLeft = deltaTime;
		timeLeft -= deltaTime;
		
		index = Math.floor(Utils.clamp((speed - timeLeft) / speed, 0.0, 1.0) * sequence.length);
		
		if (timeLeft <= 0) {
			timeLeft = 0;
			active = false;
		}
	}
	
	public function start() {
		if (sequence.length <= 0) return;
		
		active = true;
		
		reset();
	}
	
	public function stop() {
		active = false;
	}
	
	public function reset() {
		index = 0;
		timeLeft = speed;
	}
	
	public function setSpeed(spd:Float) {
		speed = spd;
	}
	
	public function addFrame(r:Rectangle) {
		var index = frames.indexOf(r);
		
		if (index < 0) {
			index = frames.push(r) - 1;
			sequence.push(index);
		} else {
			sequence.push(index);
		}
	}

	public function getUV():Rectangle {
		if (active) {
			// sicherheitshalber...
			if (index >= sequence.length) index = sequence.length - 1;
			
			return frames[sequence[index]];
		}
		
		return frames[sequence[0]];
	}
}