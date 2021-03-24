package ui;

import haxe.Utf8;
/**
 * ...
 * @author Matthias Faust
 */
class DialogInput extends DialogMessage {
	var chars:String = "";
	var index:Int = 0;
	
	public function new(screen:Screen, x:Int, y:Int, msg:String, ?smallFont:Bool=false) {
		super(screen, x, y, msg, smallFont);
		
		chars = "";
		fixInput();
	}
	
	override public function prepareText() {
		super.prepareText();
		
		this.y = this.y - 12;
		this.h = this.h + 2;
	}
	
	function fixInput() {
		chars = chars.rpad(" ", 16);
		chars = chars.substr(0, 16);
	}
	
	override public function render() {
		super.render();
		
		Tobor.fontBig.drawShadowString(this.x + offsetX + 16, this.y + (12 * (this.h - 2)), chars, Color.BLACK, Color.NEON_GREEN);
		Tobor.fontBig.drawShadowString(this.x + offsetX + 16 + index * 16, this.y + (12 * (this.h - 2)), chars.charAt(index), Color.WHITE, Color.BLACK);
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			ok();
		} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
			exit();
		} else if (Input.isKeyDown([KeyCode.LEFT])) {
			index--;
			if (index < 0) index = 0;
			Input.wait(0.25);
		} else if (Input.isKeyDown([KeyCode.RIGHT])) {
			index++;
			if (index >= 16) index = 15;
			Input.wait(0.25);
		} else if (Input.isKeyDown([KeyCode.BACKSPACE, KeyCode.NUMPAD_BACKSPACE])) {
			chars = chars.removeAt(index - 1, 1);
			index--;
			if (index < 0) index = 0;
			fixInput();
			Input.wait(0.25);
		} else if (Input.isKeyDown([KeyCode.DELETE])) {
			chars = chars.removeAt(index + 1, 1);
			fixInput();
			Input.wait(0.25);
		}
	}
	
	override public function onTextInput(text:String) {
		chars = chars.insertAt(index, text);
		
		index++;
		if (index >= 16) {
			index = 15;
		}
		
		fixInput();
	}
	
	public function getInput(?isFileName:Bool = false):String {
		if (isFileName) {
			var removeChars = ["?", "!", "\\", '"', "'", "§", "$", "%", "&", "/", "<", ">", "{", "}", ",", ";", ":", "^"];
			
			for (char in removeChars) {
				chars = chars.removeAll(char);
			}
			
			chars = chars.compact();
			
			chars = chars.replaceAll("ä", "ae");
			chars = chars.replaceAll("ö", "oe");
			chars = chars.replaceAll("ü", "ue");
			
			chars = chars.replaceAll("Ä", "Ae");
			chars = chars.replaceAll("Ö", "Oe");
			chars = chars.replaceAll("Ü", "Ue");
			
			chars = chars.replaceAll("ß", "ss");
			
			// chars = Utf8.decode(chars);
			
			return chars;
		}
		
		return chars.compact();
	}
}