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
	
	var frameSpeed:Float = 1;
	var frameTime:Float = 0;
	
	var active:Bool = false;
	
	public function new() {
	
	}
	
	public function update(deltaTime:Float) {
		if (!active) return;
		
		frameTime -= deltaTime;
		while (frameTime <= 0) {
			index++;
			if (index >= sequence.length) index = 0;
			
			frameTime += frameSpeed;
		}
	}
	
	public function start() {
		if (sequence.length <= 0) return;
		
		active = true;
		
		frameTime = frameSpeed;
		index = 0;
	}
	
	public function stop() {
		active = false;
	}
	
	public function reset() {
		index = 0;
		frameTime = frameSpeed;
	}
	
	public function setSpeed(spd:Float) {
		frameSpeed = spd / sequence.length;
	}
	
	public function addFrame(r:Rectangle) {
		var index = frames.indexOf(r);
		
		if (index < 0) {
			index = frames.push(r) - 1;
			sequence.push(index);
		} else {
			sequence.push(index);
		}
		
		trace(frames);
		trace(sequence);
	}

	public function getUV():Rectangle {
		if (active) {
			return frames[sequence[index]];
		}
		
		return frames[sequence[0]];
	}
}