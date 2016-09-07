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
		trace("onWindowCreate");
		
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
	
	// Mausevents
	
	override public function onMouseMove(window:Window, x:Float, y:Float):Void {
		super.onMouseMove(window, x, y);
		
		Input.mouseX = Std.int(x);
		Input.mouseY = Std.int(y);
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
		
		Input.key[keyCode] = true;
		
		// trace(keyCode, modifier);
	}
	
	override public function onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyUp(window, keyCode, modifier);
		
		Input.key[keyCode] = false;
	}
}