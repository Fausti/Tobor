package ui;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Dialog {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
	
	var screen:Screen;
	var child:Dialog;
	
	public var onOk:Dynamic;
	public var onCancel:Dynamic;
	
	public function new(screen:Screen, x:Int, y:Int) {
		this.screen = screen;
		
		this.x = x;
		this.y = y;
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	public function render() {
		
	}
	
	public function show() {
		
	}
	
	public function hide() {
		
	}
	
	public function exit() {
		if (onCancel != null) onCancel();
	}
	
	public function ok() {
		if (onOk != null) onOk();
	}
}