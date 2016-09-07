package gfx;

import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;

import gfx.Gfx.gl;

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
		
		var shaderVert = loadShader(gl.VERTEX_SHADER, sourceVertex);
		var shaderFrag = loadShader(gl.FRAGMENT_SHADER, sourceFragment);
		
		program = linkShader(shaderVert, shaderFrag);

		a_Position = gl.getAttribLocation(program, "a_Position");
		a_Color = gl.getAttribLocation(program, "a_Color");
		a_TexCoord0 = gl.getAttribLocation(program, "a_TexCoord0");

		u_camMatrix = gl.getUniformLocation(program, "u_camMatrix");
		u_Texture0 = gl.getUniformLocation(program, "u_Texture0");
		
	}
	
	function loadShader(type:Int, source:String):GLShader {
		var shader = gl.createShader(type);
		
		gl.shaderSource(shader, source);
		gl.compileShader(shader);
		
		var status = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
		if (status == 0) {
			trace(gl.getShaderInfoLog(shader));
		}
		
		return shader;
	}
	
	function linkShader(shaderVert:GLShader, shaderFrag:GLShader):GLProgram {
		var program = gl.createProgram();
		
		gl.attachShader(program, shaderVert);
		gl.attachShader(program, shaderFrag);
		
		gl.linkProgram(program);
		
		if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0) {
			trace(gl.getProgramInfoLog(program));
		}
		
		gl.validateProgram(program);
		
		if (gl.getProgramParameter(program, gl.VALIDATE_STATUS) == 0) {
			trace(gl.getProgramInfoLog(program));
		}
		
		return program;
	}
	
	public function use() {
		Gfx.shader = this;
		
		gl.useProgram(program);
	}
	
	public inline function setAttribute(index:Int, size:Int, type:Int, stride:Int, offset:Int) {
		gl.enableVertexAttribArray(index);
		gl.vertexAttribPointer(index, size, type, false, stride, offset);
	}
}