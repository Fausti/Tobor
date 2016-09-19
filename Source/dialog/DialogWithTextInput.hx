package dialog;

import gfx.Color;
import haxe.Utf8;
import lime.math.Rectangle;
import screens.Screen;

/**
 * ...
 * @author Matthias Faust
 */
class DialogWithTextInput extends Dialog {
	var text:Array<String>;
	
	var input:Array<String> = [];
	var inputSize:Int = 0;
	var inputPos:Int = 0;
	
	var UI_NONE:Rectangle;
	
	var result(get, null):String;
		
	public function new(screen:Screen, x:Int, y:Int, text:String, inputSize:Int) {
		super(screen, x, y);
		
		UI_NONE = Tobor.Tileset.find("SPR_NONE");
		
		this.text = text.split("\n");
		for (line in this.text) {
			this.w = Std.int(Math.max(this.w, Math.ceil(line.length)));
			trace(line, line.length);
		}
		
		this.inputSize = inputSize;
		
		reset();
	}
	
	override public function show() {
		super.show();
		
		reset();
	}
	
	public function reset() {
		input = [];
		
		for (i in 0 ... inputSize) {
			input.push(" ");
		}
		
		inputPos = 0;
	}
	
	function get_result():String {
		return StringTools.rtrim(StringTools.ltrim(input.join("")));
	}
	
	override public function update(deltaTime:Float) {
		if (Input.keyDown(Input.ESC)) {
			Input.wait(2);
			
			exit();
		}
		
		if (Input.keyDown(Input.ENTER)) {
			Input.wait(2);
			
			trace(result, result.length);
			
			exit();
		}
		
		if (Input.keyDown(Input.CURSOR_LEFT)) {
			Input.wait(2);
			inputPos--;
		}
		
		if (Input.keyDown(Input.CURSOR_RIGHT)) {
			Input.wait(2);
			inputPos++;
		}
		
		if (Input.keyDown(Input.DELETE)) {
			Input.wait(2);
			
			delete_char();
		}
		
		if (Input.keyDown(Input.BACKSPACE)) {
			Input.wait(2);
			
			if (inputPos > 0) {
				inputPos--;
				
				delete_char();
			}
		}
		
		if (inputPos >= inputSize) inputPos = inputSize - 1;
		if (inputPos < 0) inputPos = 0;
	}
	
	override public function render() {
		Tobor.Frame16.drawBox(0, 0, w + 2, text.length + 2 + 2);
		
		var offsetY:Int = 16;
		for (line in text) {
			Tobor.Font16.drawString(16, offsetY, line, Color.BLACK);
			offsetY += 10;
		}
		
		offsetY += 10;
		
		var offsetX:Int = 16;
		
		Dialog.drawBackground(offsetX, offsetY, inputSize * 16, 10);
		Dialog.drawBackground(offsetX + inputPos * 16, offsetY, 16, 10, Color.BLACK);
		
		for (charPos in 0 ... inputSize) {
			if (charPos < input.length) {
				if (charPos == inputPos) {
					Tobor.Font16.drawString(offsetX + charPos * 16, offsetY, input[charPos], Color.WHITE, Color.BLACK);
				} else {
					Tobor.Font16.drawString(offsetX + charPos * 16, offsetY, input[charPos], Color.BLACK, Color.LIGHT_GREEN);
				}
			}
		}
		
		// Dialog.drawBackground(16, offsetY + 100, inputSize * 16, 100);
		
		// Tobor.Font16.drawString(16, offsetY + 10, input, Color.BLACK);
	}
	
	override public function onTextInput(text:String) {
		text = Utf8.decode(text);
		
		if (inputPos < inputSize) {
			insert_char(text.charAt(0));
		}
		
		if (inputPos >= inputSize) inputPos = inputSize - 1;
		
		trace(input, inputPos, text);
	}
	
	function delete_char() {
		input.splice(inputPos, 1);
		input.push(" ");
	}
	
	function insert_char(char:String) {
		input.insert(inputPos, char);
		input = input.slice(0, inputSize);
		
		inputPos++;
	}
}