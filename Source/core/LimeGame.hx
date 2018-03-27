package core;

import lime.graphics.opengl.GL;

import gfx.Framebuffer;
import gfx.Shader;

/**
 * ...
 * @author Matthias Faust
 */
class LimeGame {
	private var __defaultShader:Shader;
	private var __frameBuffer:Framebuffer;
	private var __framebuffer_w:Int = 0;
	private var __framebuffer_h:Int = 0;
	
	private var __application:LimeApplication;
	
	private var __scaleX:Float = 1;
	private var __scaleY:Float = 1;
	
	public function new() {
		
	}
	
	@:final	@:noCompletion @:allow(core.LimeApplication)
	private function __init(app:LimeApplication) {
		__application = app;
		
		__defaultShader = Shader.createDefaultShader();
		__frameBuffer = new Framebuffer(__framebuffer_w, __framebuffer_h);
		
		// falls das Spielfenster initial nicht der originalen Spielgröße entspricht
		__resize(__application.window.width, __application.window.height);
		
		init();
	}
	
	@:final	@:noCompletion @:allow(core.LimeApplication)
	private function __update(deltaTime) {
		update(deltaTime);
	}
	
	@:final	@:noCompletion @:allow(core.LimeApplication)
	private function __render() {
		__frameBuffer.bind();
		
		render();
		
		__frameBuffer.unbind();

		GL.viewport(0, 0, __application.window.width, __application.window.height);
		GL.clearColor(1, 1, 1, 1.0);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		__defaultShader.use();
		__frameBuffer.draw(__application.window.width, __application.window.height);
	}
	
	@:final	@:noCompletion @:allow(core.LimeApplication)
	private function __resize(width:Int, height:Int) {
		__scaleX = width / __framebuffer_w;
		__scaleY = height / __framebuffer_h;
		
		resize(width, height);
	}
	
	public function init() {
		
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	public function render() {
		
	}
	
	public function resize(width:Int, height:Int) {
		
	}
	
	public function dispose() {
		
	}
	
	public function exit() {
		trace("exit");
		dispose();
		Sys.exit(0);
	}
	
	public function onMouseMove(x:Float, y:Float) {
		Input.mouseX = x / __scaleX;
		Input.mouseY = y / __scaleY;
	}
	
	public function onMouseButtonDown(x:Float, y:Float, button:Int) {
		Input.mouseX = x / __scaleX;
		Input.mouseY = y / __scaleY;
		
		Input.onMouseDown(button);
	}
	
	public function onMouseButtonUp(x:Float, y:Float, button:Int) {
		Input.mouseX = x / __scaleX;
		Input.mouseY = y / __scaleY;
		
		Input.onMouseUp(button);
	}
	
	public function onTextInput(text:String) {
		
	}
}