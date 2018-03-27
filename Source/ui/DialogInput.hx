package ui;

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
		chars = chars.rpad(16, " ", false);
		chars = chars.substr8(0, 16);
	}
	
	override public function render() {
		super.render();
		
		Tobor.fontBig.drawString(this.x + offsetX + 16, this.y + (12 * (this.h - 2)), chars, Color.BLACK, Color.NEON_GREEN);
		Tobor.fontBig.drawString(this.x + offsetX + 16 + index * 16, this.y + (12 * (this.h - 2)), chars.charAt8(index), Color.WHITE, Color.BLACK);
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			ok();
		} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
			exit();
		} else if (Input.isKeyDown([Input.key.LEFT])) {
			index--;
			if (index < 0) index = 0;
			Input.wait(0.25);
		} else if (Input.isKeyDown([Input.key.RIGHT])) {
			index++;
			if (index >= 16) index = 15;
			Input.wait(0.25);
		} else if (Input.isKeyDown([Input.key.BACKSPACE, Input.key.NUMPAD_BACKSPACE])) {
			chars = chars.removeAt(index - 1, 1);
			index--;
			if (index < 0) index = 0;
			fixInput();
			Input.wait(0.25);
		} else if (Input.isKeyDown([Input.key.DELETE])) {
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
		if (!isFileName) return chars.compact();
		
		return chars.compact();
	}
}