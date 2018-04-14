package core;

import lime.Assets;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLUniformLocation;

import gfx.Framebuffer;
import gfx.Shader;

/**
 * ...
 * @author Matthias Faust
 */
class LimeGame {
	private var __defaultShader:Shader;
	
	private var __shaders:Array<String> = ["hq2x", "hq4x"];
	private var __upscaleShader:Array<Shader>;
	private var __u_Scale:Array<GLUniformLocation>;
	private var __u_InputSize:Array<GLUniformLocation>;
	private var __u_OutputSize:Array<GLUniformLocation>;
	
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
		
		__upscaleShader = [];
		__u_Scale = [];
		__u_InputSize = [];
		__u_OutputSize = [];
		
		var index:Int = 0;
		for (fileName in __shaders) {
			__upscaleShader[index] = Shader.createShaderFrom(Assets.getText("assets/"+fileName+".vert"), Assets.getText("assets/"+fileName+".frag"));
		
			__u_Scale[index] = __upscaleShader[index].getUniformLocation("u_Scale");
			__u_InputSize[index] = __upscaleShader[index].getUniformLocation("u_InputSize");
			__u_OutputSize[index] = __upscaleShader[index].getUniformLocation("u_OutputSize");
			
			index++;
		}
		
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
		__defaultShader.use();
		
		__frameBuffer.bind();
		
		render();
		
		__frameBuffer.unbind();

		GL.viewport(0, 0, __application.window.width, __application.window.height);
		GL.clearColor(1, 1, 1, 1.0);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		if (Config.shader == -1) {
			__defaultShader.use();
		} else {
			__upscaleShader[Config.shader].use();
			GL.uniform2f(__u_Scale[Config.shader], __scaleX, __scaleY);
			GL.uniform2f(__u_OutputSize[Config.shader], __application.window.width, __application.window.height);
			GL.uniform2f(__u_InputSize[Config.shader], __framebuffer_w, __framebuffer_h);
		}
		
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
		onExit();
		dispose();
		Sys.exit(0);
	}
	
	public function onExit() {
		
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
	
	public function onDropFile(fileName:String) {
		
	}
}