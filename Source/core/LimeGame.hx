package core;

import lime.Lib;
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
	
	public function new() {
		
	}
	
	@:final	@:noCompletion @:allow(core.LimeApplication)
	private function __init(app:LimeApplication) {
		__application = app;
		
		__defaultShader = Shader.createDefaultShader();
		__frameBuffer = new Framebuffer(__framebuffer_w, __framebuffer_h);
		
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
}