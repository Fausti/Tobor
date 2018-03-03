package gfx;

import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GL;

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
		
		vertexBuffer = GL.createBuffer();
		indexBuffer = GL.createBuffer();
	}
	
	public function bind() {
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		if (needRedraw) {
			GL.bufferData(GL.ARRAY_BUFFER, vertices.length * Float32Array.BYTES_PER_ELEMENT, getVertices(), GL.STATIC_DRAW);
		}
		
		if (isIndexed) {
			GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
			if (needRedraw) {
				GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices.length * Int16Array.BYTES_PER_ELEMENT, getIndices(), GL.STATIC_DRAW);
			}
		}
		
		Shader.current.setAttribute(Shader.current.a_Position, 2, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Shader.current.setAttribute(Shader.current.a_Color, 4, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
	}
	
	public function draw() {
		if (isIndexed) {
			GL.drawElements(GL.TRIANGLES, length, GL.UNSIGNED_SHORT, 0);
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