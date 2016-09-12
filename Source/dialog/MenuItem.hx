package dialog;

/**
 * ...
 * @author Matthias Faust
 */
class MenuItem {
	public var text:String = "";
	
	public var strName:String = "";
	public var strGap:String = "";
	public var strKey:String = "";
	
	public function new(name:String, key:String) {
		strName = name + " ";
		strKey = key;
		
		this.text = strName + strKey;
	}
	
	public function resize(w:Int) {
		var l:Int = strKey.length;
		
		strName = StringTools.rpad(strName, " ", w - l);
		
		text = strName + strKey;
	}
}