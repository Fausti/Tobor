package ui;

/**
 * ...
 * @author Matthias Faust
 */
class MenuItem {
	public var text:String = "";
	
	public var strName:String = "";
	public var strGap:String = "";
	public var strKey:String = "";
	
	public var cb:Dynamic;
	
	public function new(name:String, key:String, ?cb:Dynamic) {
		strName = name + " ";
		strKey = key;
		
		this.cb = cb;
		
		this.text = strName + strKey;
	}
	
	public function resize(w:Int) {
		var l:Int = strKey.length;
		
		strName = StringTools.rpad(strName, " ", w - l);
		
		text = strName + strKey;
	}

	public function hasCallback():Bool {
		return (cb != null);
	}
	
	public function call() {
		if (hasCallback()) {
			cb();
		}
	}
}