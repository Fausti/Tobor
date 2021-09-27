package core;
import lime.graphics.RenderContext;
import lime.math.Vector2;
import lime.system.Display;
import lime.system.System;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.MouseWheelMode;
import lime.ui.Touch;

import lime.app.Application;
import lime.ui.Gamepad;

import lime.ui.KeyModifier;
import lime.ui.KeyCode;

/**
 * ...
 * @author Matthias Faust
 */
class LimeApplication extends Application {
	var game:LimeGame;
	var display:Display;
	
	public function new () {
		super ();
	}
	
	public function init() {
		
	}
	
	override public function onWindowCreate():Void {
		switch(this.window.context.type) {
			case OPENGL, OPENGLES, WEBGL:
				trace(window.context.type + " " + window.context.version);
				Gfx.gl = window.context.webgl;
				
				var supported_extensions = Gfx.gl.getSupportedExtensions();
				trace(supported_extensions);
				
				init();
				
			default:
		}
		
				
		display = System.getDisplay(0);
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

	override public function render(renderer:RenderContext):Void {
		if (!preloader.complete) return;
		
		switch(window.context.type) {
			case OPENGL, OPENGLES, WEBGL:
				if (game != null) {
					Gfx.gl = window.context.webgl;
					game.__render();
				}
				
			default:
		}
	}
	
	override public function onWindowResize(width:Int, height:Int):Void {
		super.onWindowResize(width, height);
		
		if (!preloader.complete) return;
		if (game != null) game.__resize(width, height);
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyDown(keyCode, modifier);
		
		if ((keyCode == KeyCode.RETURN || keyCode == KeyCode.RETURN2) && (modifier == KeyModifier.ALT || modifier == KeyModifier.LEFT_ALT || modifier == KeyModifier.RIGHT_ALT)) {
			return;
		}
		
		Input.onKeyDown(keyCode, modifier);
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {
		super.onKeyUp(keyCode, modifier);
		
		if ((keyCode == KeyCode.RETURN || keyCode == KeyCode.RETURN2) && (modifier == KeyModifier.ALT || modifier == KeyModifier.LEFT_ALT || modifier == KeyModifier.RIGHT_ALT)) {
			return;
		}
		
		Input.onKeyUp(keyCode, modifier);
	}
	
	// Maus
	
	override public function onMouseMove(x:Float, y:Float):Void {
		super.onMouseMove(x, y);
		
		if (game != null) game.onMouseMove(x, y);
	}
	
	override public function onMouseDown(x:Float, y:Float, button:Int):Void {
		super.onMouseDown(x, y, button);
		
		if (game != null) game.onMouseButtonDown(x, y, button);
	}
	
	override public function onMouseUp(x:Float, y:Float, button:Int):Void {
		super.onMouseUp(x, y, button);
		
		if (game != null) game.onMouseButtonUp(x, y, button);
	}
	
	override public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void {
		super.onMouseWheel(deltaX, deltaY, deltaMode);
		
		Input.onMouseWheel(deltaX, deltaY);
	}
	
	// Touch
	
	override public function onTouchStart(touch:Touch):Void {
		super.onTouchStart(touch);
		if (game != null) {
			game.onMouseButtonDown(
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y, 
				0
			);
			
			/*
			trace(
				"onTouchStart: ", 
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y
			);
			*/
		}
	}
	
	override public function onTouchEnd(touch:Touch):Void {
		super.onTouchEnd(touch);
		if (game != null) {
			game.onMouseButtonUp(
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y, 
				0
			);
			
			/*
			trace(
				"onTouchEnd: ", 
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y
			);
			*/
		}
	}
	
	override public function onTouchMove(touch:Touch):Void 	{
		super.onTouchMove(touch);
		if (game != null) {
			game.onMouseButtonDown(
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y, 
				0
			);
			
			/*
			trace(
				"onTouchMove: ", 
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y
			);
			*/
		}
	}
	
	override public function onTouchCancel(touch:Touch):Void {
		super.onTouchCancel(touch);
		if (game != null) {
			game.onMouseButtonUp(
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y, 
				0
			);
			
			/*
			trace(
				"onTouchCancel: ", 
				touch.x * display.currentMode.width - this.window.x, 
				touch.y * display.currentMode.height - this.window.y
			);
			*/
		}
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
	
	override public function onTextInput(text:String):Void 
	{
		if (game != null) game.onTextInput(text);
	}
	
	override public function onWindowClose():Void {
		if (game != null) game.onExit();
		
		super.onWindowClose();
	}
	
	// Drag N Drop
	
	override public function onWindowDropFile(file:String):Void {
		super.onWindowDropFile(file);
		
		if (game != null) game.onDropFile(file);
	}
}