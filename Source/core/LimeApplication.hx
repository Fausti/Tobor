package core;

import lime.app.Application;

import lime.graphics.Renderer;

import lime.ui.KeyModifier;
import lime.ui.KeyCode;
import lime.ui.Mouse;
import lime.ui.Window;

/**
 * ...
 * @author Matthias Faust
 */
class LimeApplication extends Application {
	var game:LimeGame;
	
	public function new () {
		super ();
	}
	
	public function init() {
		
	}
	
	override public function onWindowCreate(window:Window):Void {
		switch(window.renderer.context) {
			case OPENGL(gl):
				init();
				
			default:
		}
	}
	
	override public function onPreloadComplete():Void {
		super.onPreloadComplete();

		if (game != null) game.__init(this);
	}
	
	override public function update(deltaTime:Int):Void {
		if (!preloader.complete) return;
		
		super.update(deltaTime);
		
		if (game != null) game.__update(deltaTime / 1000.0);
	}
	
	
	override public function render(renderer:Renderer):Void {
		if (!preloader.complete) return;
		
		switch(window.renderer.context) {
			case OPENGL(gl):
				if (game != null) game.__render();
				
			default:
		}
	}
	
	override public function onWindowResize(window:Window, width:Int, height:Int):Void {
		super.onWindowResize(window, width, height);
		
		if (!preloader.complete) return;
		if (game != null) game.__resize(width, height);
	}
	
	override public function onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyDown(window, keyCode, modifier);
		
		Input.onKeyDown(keyCode, modifier);
	}
	
	override public function onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyUp(window, keyCode, modifier);
		
		Input.onKeyUp(keyCode, modifier);
	}
}