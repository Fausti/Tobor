package gfx;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Animation extends Sprite {
	var frames:Array<Sprite>;
	var frame:Sprite;
	
	var length:Float;
	var timeLeft:Float = 0;
	
	var active:Bool;
	
	public var onAnimationEnd:Dynamic;
	
	public function new(frames:Array<Sprite>, length:Float) {
		super();
		
		this.frames = frames;
		this.length = length;
		
		reset();
		
		width = frame.width;
		height = frame.height;
		
		active = false;
	}
	
	public function reset() {
		frame = frames[0];
		timeLeft = length;
	}
	
	public function start(?reset:Bool = false) {
		if (reset) reset;
		
		active = true;
	}
	
	public function stop(?reset:Bool = false) {
		if (reset) reset;
		
		active = false;
	}
	
	override public function update(deltaTime:Float) {
		if (!active) return;
		
		timeLeft = timeLeft - deltaTime;
		if (timeLeft < 0) {
			if (onAnimationEnd != null) onAnimationEnd();
			timeLeft = timeLeft + length;
		}
		
		var index:Int = Std.int(((length - timeLeft) * frames.length) / length);
		// trace(index);
		
		frame = frames[index];
	}
	
	override function get_uv():Rectangle {
		return frame.uv;
	}
	
	override function get_color():Color {
		return frame.color;
	}
	
	override function set_color(c:Color):Color {
		for (f in frames) {
			f.color = c;
		}
		
		return c;
	}
}