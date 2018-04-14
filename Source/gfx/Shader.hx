package gfx;

import lime.graphics.opengl.GL;
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
		
		var shaderVert = loadShader(GL.VERTEX_SHADER, sourceVertex);
		var shaderFrag = loadShader(GL.FRAGMENT_SHADER, sourceFragment);
		
		program = linkShader(shaderVert, shaderFrag);

		a_Position = GL.getAttribLocation(program, "a_Position");
		a_Color = GL.getAttribLocation(program, "a_Color");
		a_TexCoord0 = GL.getAttribLocation(program, "a_TexCoord0");

		u_camMatrix = GL.getUniformLocation(program, "u_camMatrix");
		u_Texture0 = GL.getUniformLocation(program, "u_Texture0");
		
	}
	
	public function getUniformLocation(key:String):GLUniformLocation {
		return GL.getUniformLocation(program, key);
	}
	
	function loadShader(type:Int, source:String):GLShader {
		var shader = GL.createShader(type);
		
		GL.shaderSource(shader, source);
		GL.compileShader(shader);
		
		var status = GL.getShaderParameter(shader, GL.COMPILE_STATUS);
		if (status == 0) {
			trace(GL.getShaderInfoLog(shader));
		}
		
		return shader;
	}
	
	function linkShader(shaderVert:GLShader, shaderFrag:GLShader):GLProgram {
		var program = GL.createProgram();
		
		GL.attachShader(program, shaderVert);
		GL.attachShader(program, shaderFrag);
		
		GL.linkProgram(program);
		
		if (GL.getProgramParameter(program, GL.LINK_STATUS) == 0) {
			trace(GL.getProgramInfoLog(program));
		}
		
		GL.validateProgram(program);
		
		if (GL.getProgramParameter(program, GL.VALIDATE_STATUS) == 0) {
			trace(GL.getProgramInfoLog(program));
		}
		
		return program;
	}
	
	public function use() {
		Shader.current = this;
		
		GL.useProgram(program);
	}
	
	public inline function setAttribute(index:Int, size:Int, type:Int, stride:Int, offset:Int) {
		GL.enableVertexAttribArray(index);
		GL.vertexAttribPointer(index, size, type, false, stride, offset);
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