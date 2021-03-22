package gfx;

import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.graphics.opengl.GLBuffer;

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
	
	public function new(?isIndexed:Bool = true) {
		vertices = new Array<Float>();
		indices = new Array<Int>();
		this.isIndexed = isIndexed;
		
		clear();
		
		vertexBuffer = Gfx.gl.createBuffer();
		indexBuffer = Gfx.gl.createBuffer();
	}
	
	public function bind() {
		Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, vertexBuffer);
		if (needRedraw) {
			// Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, vertices.length * Float32Array.BYTES_PER_ELEMENT, getVertices(), Gfx.gl.STATIC_DRAW);
			Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, getVertices(), Gfx.gl.STATIC_DRAW);
		}
		
		if (isIndexed) {
			Gfx.gl.bindBuffer(Gfx.gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			if (needRedraw) {
				// Gfx.gl.bufferData(Gfx.gl.ELEMENT_ARRAY_BUFFER, indices.length * Int16Array.BYTES_PER_ELEMENT, getIndices(), Gfx.gl.STATIC_DRAW);
				Gfx.gl.bufferData(Gfx.gl.ELEMENT_ARRAY_BUFFER, getIndices(), Gfx.gl.STATIC_DRAW);
			}
		}
		
		Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
	}
	
	public function draw() {
		if (isIndexed) {
			Gfx.gl.drawElements(Gfx.gl.TRIANGLES, length, Gfx.gl.UNSIGNED_SHORT, 0);
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