package ui;

/**
 * ...
 * @author Matthias Faust
 */
class DialogQuestion extends DialogMessage {
	public var index:Int = 0;

	public var strOK:String = GetText.get("TXT_DIALOG_OK");
	public var strCancel:String = GetText.get("TXT_DIALOG_CANCEL");
	
	public function new(screen:Screen, x:Int, y:Int, msg:String, ?smallFont:Bool=false) {
		super(screen, x, y, msg, smallFont);
		
		this.y = this.y - 12;
		this.h = this.h + 2;
		
		if (index > 1) index = 1;
		if (index < 0) index = 0;
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			if (index == 0) ok();
			else exit();
		} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
			exit();
		} else if (Input.isKeyDown([KeyCode.LEFT])) {
			index--;
			if (index < 0) index = 0;
			Input.wait(0.25);
		} else if (Input.isKeyDown([KeyCode.RIGHT])) {
			index++;
			if (index >= 2) index = 1;
			Input.wait(0.25);
		}
	}
	
	override public function render() {
		Tobor.frameBig.drawBox(x, y, w, h);
		
		var i = 0;
		for (line in lines) {
			var fg:Color = Color.BLACK;
			var bg:Color = Color.WHITE;
			
			if (i == 0) {
				fg = Color.WHITE;
				bg = Color.BLACK;
			}
			
			if (smallFont) {
				Tobor.fontSmall.drawString(x + 16 + offsetX, y + 12 + i * 12, line, fg, bg);
			} else {
				Tobor.fontBig.drawString(x + 16 + offsetX, y + 12 + i * 12, line, fg, bg);
			}
			i++;
		}
		
		if (index == 0) {
			Tobor.fontBig.drawString(this.x + offsetX + 16, this.y + (12 * (this.h - 2)), "[ " + strOK + " ]", Color.BLACK, Color.NEON_GREEN);
			Tobor.fontBig.drawString(this.x + offsetX + ((this.w - strCancel.length - 4 - 1) * 16), this.y + (12 * (this.h - 2)), "[ " + strCancel + " ]", Color.BLACK);
		} else {
			Tobor.fontBig.drawString(this.x + offsetX + 16, this.y + (12 * (this.h - 2)), "[ " + strOK + " ]", Color.BLACK);
			Tobor.fontBig.drawString(this.x + offsetX + ((this.w - strCancel.length - 4 - 1) * 16), this.y + (12 * (this.h - 2)), "[ " + strCancel + " ]", Color.BLACK, Color.NEON_GREEN);
		}
	}
}