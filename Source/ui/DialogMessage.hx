package ui;

/**
 * ...
 * @author Matthias Faust
 */
class DialogMessage extends Dialog {
	var smallFont:Bool;
	
	var msg:String;
	var lines:Array<String>;
	
	var offsetX:Int = 0;
	
	var maxWidth:Int = 32;
	
	public function new(screen:Screen, x:Int, y:Int, msg:String, ?smallFont:Bool = false) {
		super(screen, x, y);
		
		this.smallFont = smallFont;
		
		this.msg = StringTools.replace(msg, "\r", "");
		
		prepareText();
	}
	
	public function prepareText() {
		lines = msg.split("\n");
		
		this.w = 0;
		for (line in lines) {
			if (line.length > this.w) this.w = line.length;
		}
		
		if (smallFont) {
			if (this.w % 2 == 1) offsetX = 4;
			this.w = Math.ceil(this.w / 2);
		}
		
		this.w = this.w + 2;
		
		if (this.w >= maxWidth) splitText();
		
		this.h = lines.length + 2;
		
		this.x = Math.floor(40 / 2 - this.w / 2) * 16;
		this.y = Math.floor(27 / 2 - (this.h + 2) / 2) * 12;
		
		if (this.w % 2 == 1) this.x = this.x + 16;
	}
	
	function splitText() {
		lines = [];
		var nlines:Array<String> = msg.split("\n");
		
		this.w = 0;
		
		var lineSize:Int = 0;
		
		for (nline in nlines) {
			var l = nline.length;
			
			if (l > maxWidth) {
				lineSize = 0;
				var words:Array<String> = nline.split(" ");
				var ll:String = "";
				
				for (word in words) {
					if ((lineSize + word.length + 1) >= maxWidth) {
						lines.push(ll);
						ll = "";
						lineSize = 0;
					}
					
					if (ll == "") {
						ll = ll + word;
					} else {
						ll = ll + " " + word;
					}
						
					lineSize = ll.length;
				}
				
				if (ll != "") {
					lines.push(ll);
				}
			} else {
				lines.push(nline);
			}
		}
		
		for (line in lines) {
			var l = line.length;
			if (l > this.w) this.w = l;
		}
			
		if (smallFont) {
			if (this.w % 2 == 1) offsetX = 4;
			this.w = Math.ceil(this.w / 2);
		}
		
		this.w = this.w + 2;
	}
	
	override public function show() {
		super.show();
		
		Input.clearKeys();
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (Input.isKeyDown([KeyCode.ESCAPE, KeyCode.RETURN, KeyCode.RETURN2])) {
			exit();
		} else if (Input.mouseBtnLeft || Input.mouseBtnRight) {
			exit();
		}
	}
	
	override public function ok() {
		super.ok();
	}
	
	override public function exit() {
		super.exit();
	}
	
	override public function render() {
		Tobor.frameBig.drawBox(x, y, w, h);
		
		var i = 0;
		for (line in lines) {
			if (smallFont) {
				Tobor.fontSmall.drawShadowString(x + 16 + offsetX, y + 12 + i * 12, line, Color.BLACK);
			} else {
				Tobor.fontBig.drawShadowString(x + 16 + offsetX, y + 12 + i * 12, line, Color.BLACK);
			}
			i++;
		}
	}
}