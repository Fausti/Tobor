package core;
import lime.math.Vector2;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;

import lime.app.Application;
import lime.ui.Gamepad;

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

		// init();
		if (game != null) game.__init(this);
	}
	
	override public function update(deltaTime:Int):Void {
		if (!preloader.complete) return;
		
		super.update(deltaTime);
		
		var dt:Float = 1 / 60; // deltaTime / 1000.0;
		
		Input.update(dt);
		if (game != null) game.__update(dt);
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
	
	// Maus
	
	override public function onMouseMove(window:Window, x:Float, y:Float):Void {
		super.onMouseMove(window, x, y);
		
		if (game != null) game.onMouseMove(x, y);
	}
	
	override public function onMouseDown(window:Window, x:Float, y:Float, button:Int):Void {
		super.onMouseDown(window, x, y, button);
		
		if (game != null) game.onMouseButtonDown(x, y, button);
	}
	
	override public function onMouseUp(window:Window, x:Float, y:Float, button:Int):Void {
		super.onMouseUp(window, x, y, button);
		
		if (game != null) game.onMouseButtonUp(x, y, button);
	}
	
	// Gamepad!
	
	private var gamepadDirection:Vector2 = new Vector2(0, 0);
	
	override public function onGamepadAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		var minValue:Float = 0.25;
		
		switch(axis) {
			case GamepadAxis.LEFT_X:
				gamepadDirection.x = value;
			case GamepadAxis.LEFT_Y:
				gamepadDirection.y = value;
			default:
				return;
		}
		
		if (gamepadDirection.x <= -minValue) {
			Input.onKeyDown(KeyCode.LEFT, KeyModifier.NONE);
			Input.onKeyUp(KeyCode.RIGHT, KeyModifier.NONE);
		} else if (gamepadDirection.x >= minValue) {
			Input.onKeyUp(KeyCode.LEFT, KeyModifier.NONE);
			Input.onKeyDown(KeyCode.RIGHT, KeyModifier.NONE);
		} else {
			Input.onKeyUp(KeyCode.LEFT, KeyModifier.NONE);
			Input.onKeyUp(KeyCode.RIGHT, KeyModifier.NONE);
		}
		
		if (gamepadDirection.y <= -minValue) {
			Input.onKeyDown(KeyCode.UP, KeyModifier.NONE);
			Input.onKeyUp(KeyCode.DOWN, KeyModifier.NONE);
		} else if (gamepadDirection.y >= minValue) {
			Input.onKeyUp(KeyCode.UP, KeyModifier.NONE);
			Input.onKeyDown(KeyCode.DOWN, KeyModifier.NONE);
		} else {
			Input.onKeyUp(KeyCode.UP, KeyModifier.NONE);
			Input.onKeyUp(KeyCode.DOWN, KeyModifier.NONE);
		}
	}
	
	override public function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton):Void {
		switch(button) {
			case GamepadButton.DPAD_DOWN:
				Input.onKeyDown(KeyCode.DOWN, KeyModifier.NONE);
			case GamepadButton.DPAD_UP:
				Input.onKeyDown(KeyCode.UP, KeyModifier.NONE);
			case GamepadButton.DPAD_LEFT:
				Input.onKeyDown(KeyCode.LEFT, KeyModifier.NONE);
			case GamepadButton.DPAD_RIGHT:
				Input.onKeyDown(KeyCode.RIGHT, KeyModifier.NONE);
			default:
				
		}
	}
	
	override public function onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton):Void {
		switch(button) {
			case GamepadButton.DPAD_DOWN:
				Input.onKeyUp(KeyCode.DOWN, KeyModifier.NONE);
			case GamepadButton.DPAD_UP:
				Input.onKeyUp(KeyCode.UP, KeyModifier.NONE);
			case GamepadButton.DPAD_LEFT:
				Input.onKeyUp(KeyCode.LEFT, KeyModifier.NONE);
			case GamepadButton.DPAD_RIGHT:
				Input.onKeyUp(KeyCode.RIGHT, KeyModifier.NONE);
			default:
				
		}
	}
	
	override public function onTextInput(window:Window, text:String):Void 
	{
		if (game != null) game.onTextInput(text);
	}
}