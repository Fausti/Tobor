package gfx;

import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;

/**
 * ...
 * @author Matthias Faust
 */
class Shader {
	public var program:GLProgram;
	
	public var u_camMatrix:GLUniformLocation;
	public var u_Texture0:GLUniformLocation;
	
	public var a_Position:Int;
	public var a_Color:Int;
	public var a_TexCoord0:Int;
	
	public function new(?sourceVertex = null, ?sourceFragment = null) {
		if (sourceVertex == null) return;
		if (sourceFragment == null) return;
		
		var shaderVert = loadShader(Gfx.gl.VERTEX_SHADER, sourceVertex);
		var shaderFrag = loadShader(Gfx.gl.FRAGMENT_SHADER, sourceFragment);
		
		program = linkShader(shaderVert, shaderFrag);

		a_Position = Gfx.gl.getAttribLocation(program, "a_Position");
		a_Color = Gfx.gl.getAttribLocation(program, "a_Color");
		a_TexCoord0 = Gfx.gl.getAttribLocation(program, "a_TexCoord0");

		u_camMatrix = Gfx.gl.getUniformLocation(program, "u_camMatrix");
		u_Texture0 = Gfx.gl.getUniformLocation(program, "u_Texture0");
		
	}
	
	public function getUniformLocation(key:String):GLUniformLocation {
		return Gfx.gl.getUniformLocation(program, key);
	}
	
	function loadShader(type:Int, source:String):GLShader {
		var shader = Gfx.gl.createShader(type);
		
		Gfx.gl.shaderSource(shader, source);
		Gfx.gl.compileShader(shader);
		
		var status = Gfx.gl.getShaderParameter(shader, Gfx.gl.COMPILE_STATUS);
		if (status == 0) {
			trace(Gfx.gl.getShaderInfoLog(shader));
		}
		
		return shader;
	}
	
	function linkShader(shaderVert:GLShader, shaderFrag:GLShader):GLProgram {
		var program = Gfx.gl.createProgram();
		
		Gfx.gl.attachShader(program, shaderVert);
		Gfx.gl.attachShader(program, shaderFrag);
		
		Gfx.gl.linkProgram(program);
		
		if (Gfx.gl.getProgramParameter(program, Gfx.gl.LINK_STATUS) == 0) {
			trace(Gfx.gl.getProgramInfoLog(program));
		}
		
		Gfx.gl.validateProgram(program);
		
		if (Gfx.gl.getProgramParameter(program, Gfx.gl.VALIDATE_STATUS) == 0) {
			trace(Gfx.gl.getProgramInfoLog(program));
		}
		
		return program;
	}
	
	public function use() {
		Shader.current = this;
		
		Gfx.gl.useProgram(program);
	}
	
	public inline function setAttribute(index:Int, size:Int, type:Int, stride:Int, offset:Int) {
		Gfx.gl.enableVertexAttribArray(index);
		Gfx.gl.vertexAttribPointer(index, size, type, false, stride, offset);
	}
	
	public static var current:Shader = null;
	
	public static function createDefaultShader():Shader {
		return new Shader(VERT_SPRITE_RAW, FRAG_SPRITE_RAW);
	}
	
	public static function createShaderFrom(vertIn:String, fragIn:String):Shader {
		return new Shader(vertIn, fragIn);
	}
	
	public static inline var VERT_SPRITE_RAW:String =
		// "precision mediump float;" + 
		
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
		// "precision mediump float;" +
		
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