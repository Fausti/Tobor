package;
import lime.ui.KeyModifier;

import gfx.Gfx;
import lime.app.Application;
import lime.graphics.Renderer;
import lime.ui.KeyCode;
import lime.ui.Mouse;
import lime.ui.Window;

class Main extends Application {
	
	var game:Tobor;
	
	public function new () {
		super ();
	}
	
	override public function onWindowCreate(window:Window):Void {
		switch(window.renderer.context) {
			case OPENGL(gl):
				Gfx.gl = gl;
				
				game = new Tobor(window);
				
				// Mausposition im Spielfenster sicherstellen!
				// - funktioniert nur bei nativem Target :(
				
				Mouse.lock = true;
				Mouse.lock = false;
				
			default:
		}
		
		// super.onWindowCreate(window);
		
		/*
		var expr = "var x = 4; 1 + 2 * x";
		var parser = new hscript.Parser();
		var ast = parser.parseString(expr);
		var interp = new hscript.Interp();
		trace(interp.execute(ast));
		*/
	}
	
	override public function onPreloadComplete():Void {
		super.onPreloadComplete();
		
		game.init();
	}
	
	override public function update(deltaTime:Int):Void {
		super.update(deltaTime);
		
		game.update(deltaTime / 1000.0);
	}
	
	
	override public function render(renderer:Renderer):Void {
		switch(window.renderer.context) {
			case OPENGL(gl):
				Gfx.gl = gl;
				
			default:
		}
		
		game.render();
		// super.render(renderer);
	}
	
	override public function onWindowResize(window:Window, width:Int, height:Int):Void {
		super.onWindowResize(window, width, height);
		
		game.onResize(width, height);
	}
	
	// Mausevents
	
	public function updateMouse(x:Float, y:Float) {
		Input.mouseX = Std.int(x);
		Input.mouseY = Std.int(y);
	}
	
	override public function onMouseMove(window:Window, x:Float, y:Float):Void {
		super.onMouseMove(window, x, y);
		
		updateMouse(x, y);
		
		game.onMouseMove(x, y);
	}
	
	override public function onMouseDown(window:Window, x:Float, y:Float, button:Int):Void {
		super.onMouseDown(window, x, y, button);
		
		updateMouse(x, y);
		
		switch(button) {
			case 0:
				Input.mouseBtnLeft = true;
			case 1:
				Input.mouseBtnMiddle = true;
			case 2:
				Input.mouseBtnRight = true;
			default:
				trace("Mousebutton: " + button);
		}
	}
	
	override public function onMouseUp(window:Window, x:Float, y:Float, button:Int):Void {
		super.onMouseUp(window, x, y, button);
		
		updateMouse(x, y);
		
		switch(button) {
			case 0:
				Input.mouseBtnLeft = false;
			case 1:
				Input.mouseBtnMiddle = false;
			case 2:
				Input.mouseBtnRight = false;
			default:
				trace("Mousebutton: " + button);
		}
	}
	
	override public function onWindowEnter(window:Window):Void {
		super.onWindowEnter(window);
		
		Input.mouseInside = true;
	}
	
	override public function onWindowLeave(window:Window):Void {
		super.onWindowLeave(window);
		
		Input.mouseInside = false;
	}
	
	// Tastaturevents
	
	override public function onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyDown(window, keyCode, modifier);
		
		Input.setKey(keyCode, true);
	}
	
	override public function onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyUp(window, keyCode, modifier);
		
		Input.setKey(keyCode, false);
	}
}