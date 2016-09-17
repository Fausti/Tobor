package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class Message {
	public var msg:String;
	public var sender:Object;
	public var answers:Int;
	
	public function new(sender:Object, msg:String) {
		this.sender = sender;
		this.msg = msg;
		this.answers = 0;
	}
	
	public function done() {
		answers++;
	}
	
	public function toString():String {
		return "" + sender + " => " + msg;
	}
}