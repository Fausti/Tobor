package gfx;

import haxe.ds.Vector;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.graphics.opengl.GLBuffer;

import gfx.Gfx.gl;

/**
 * ...
 * @author Matthias Faust
 */
class Batch {
	public static var MAX_SIZE:Int = 1024;
	var isIndexed:Bool = false;
	
	var vertices:Array<Float>;
	var indices:Array<Int>;
	
	var posVertices:Int = 0;
	var posIndices:Int = 0;
	
	var index:Int = 0;
	
	var needRedraw:Bool = true;
	
	var vertexBuffer:GLBuffer;
	var indexBuffer:GLBuffer;
	
	public var length(get, null):Int;
	
	public function new(?isIndexed:Bool = false) {
		vertices = new Array<Float>();
		indices = new Array<Int>();
		this.isIndexed = isIndexed;
		
		clear();
		
		vertexBuffer = gl.createBuffer();
		indexBuffer = gl.createBuffer();
	}
	
	public function bind() {
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		if (needRedraw) {
			gl.bufferData(gl.ARRAY_BUFFER, getVertices(), gl.STATIC_DRAW);
		}
		
		if (isIndexed) {
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			if (needRedraw) {
				gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, getIndices(), gl.STATIC_DRAW);
			}
		}
		
		Gfx.shader.setAttribute(Gfx.shader.a_Position, 2, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Gfx.shader.setAttribute(Gfx.shader.a_TexCoord0, 2, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Gfx.shader.setAttribute(Gfx.shader.a_Color, 4, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
	}
	
	public function draw() {
		if (isIndexed) {
			gl.drawElements(gl.TRIANGLES, length, gl.UNSIGNED_SHORT, 0);
		}
		
		needRedraw = false;
	}
	
	public function clear() {
		posVertices = 0;
		posIndices = 0;
		
		index = 0;
		
		needRedraw = true;
	}
	
	public inline function pushVertexData(data:Float) {
		vertices[posVertices] = data;
		posVertices++;
	}
	
	public inline function pushVertex(x:Float, y:Float, u:Float, v:Float, r:Float, g:Float, b:Float, a:Float) {
		pushVertexData(x);
		pushVertexData(y);
		
		pushVertexData(u);
		pushVertexData(v);
		
		pushVertexData(r);
		pushVertexData(g);
		pushVertexData(b);
		pushVertexData(a);
	}
	
	public inline function add(data:Array<Float>) {
		for (i in 0 ... data.length) {
			pushVertexData(data[i]);
		}
	}
	
	public function addIndices(data:Array<Int>) {
		var num:Int = 0;
		
		for (i in 0 ... data.length) {
			// indices.push(data[i] + index);
			indices[posIndices] = data[i] + index;
			posIndices++;
			
			if ((data[i] + 1) > num) num = Std.int(data[i] + 1);
		}
		
		index = index + num;
	}
	
	public inline function getVertices():Float32Array {
		return new Float32Array(vertices);
	}
	
	public inline function getIndices():Int16Array {
		return new Int16Array(indices);
	}
	
	inline function get_length():Int {
		if (!isIndexed) {
			return posVertices;
		} else {
			return posIndices;
		}
	}
}