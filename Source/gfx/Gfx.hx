package gfx;

import lime.graphics.GLRenderContext;
import lime.math.Rectangle;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class Gfx {
	public static var gl:GLRenderContext;
	
	static var batchCurrent:Batch;
	static var colorCurrent:Color;
	static var shaderCurrent:Shader;
	
	static var offsetX:Int = 0;
	static var offsetY:Int = 0;
	
	public static var scaleX:Float = 0;
	public static var scaleY:Float = 0;
	
	public static function setOffset(x:Int, y:Int) {
		offsetX = x;
		offsetY = y;
	}
	
	public static inline function setBatch(batch:Batch) {
		Gfx.batchCurrent = batch;
	}
	
	public static inline function setColor(color:Color) {
		Gfx.colorCurrent = color;
	}
	
	public static var shader(get, set):Shader;
	
	static inline function get_shader():Shader {
		return shaderCurrent;
	}
	
	static inline function set_shader(shader:Shader):Shader {
		Gfx.shaderCurrent = shader;
		
		return shaderCurrent;
	}
	
	public static inline function setViewport(x:Int, y:Int, w:Int, h:Int) {
		gl.viewport(x, y, w, h);
	}
	
	public static inline function clear(color:Color) {
		gl.clearColor(color.r, color.g, color.b, 1.0);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	}
	
	public static inline function drawTexture(x:Float, y:Float, w:Float, h:Float, rect:Rectangle, ?color:Color = null) {
		if (batchCurrent == null) {
			trace("GFX ERROR: No batch bound!");
		}
		
		if (color == null) color = colorCurrent;
		
		batchCurrent.pushVertex(
			offsetX + x, 
			offsetY + y, 			
			rect.left, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		batchCurrent.pushVertex(
			offsetX + x, 
			offsetY + y + h, 		
			rect.left, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		batchCurrent.pushVertex(
			offsetX + x + w, 
			offsetY + y + h, 	
			rect.right, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		batchCurrent.pushVertex(
			offsetX + x + w, 
			offsetY + y, 		
			rect.right, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		batchCurrent.addIndices([0, 1, 2, 2, 3, 0]);
	}
	
	public static inline function drawRect(x:Float, y:Float, rect:Rectangle, ?color:Color = null) {
		drawTexture(x, y, Entity.WIDTH, Entity.HEIGHT, rect, color);
	}
	
	// Tileset
	
	
	
	public static inline var VERT_SPRITE_RAW:String =
		"precision mediump float;" + 
		
		"attribute vec4 a_Position;" + 
		"attribute vec2 a_TexCoord0;" +
		"attribute vec4 a_Color;" + 
		
		"uniform mat4 u_camMatrix;" +
        
		"varying vec2 v_TexCoord0;" +
		"varying vec4 v_Color;" +
		
		"void main(void) {" +
		"    v_TexCoord0 = a_TexCoord0;" +
		"    v_Color = a_Color;" + 
		"    gl_Position = u_camMatrix * a_Position;" +
		"}"
	;
	
	public static inline var FRAG_SPRITE_RAW:String =
		"precision mediump float;" +
		
		"uniform sampler2D u_Texture0;" +
		
		"varying vec2 v_TexCoord0;" + 
		"varying vec4 v_Color;" +
		
		"void main(void) {" +
		"    vec4 texColor = texture2D(u_Texture0, v_TexCoord0);" +
		"    if (texColor.a == 0.0) discard;" +
		"    gl_FragColor = texColor * v_Color;" +
		"}"
	;
}