package;

/**
 * ...
 * @author Matthias Faust
 */
class Debug {
	public static function log(o:Dynamic, msg:Dynamic) {
#if debug
		trace(Type.getClassName(Type.getClass(o)) + ": " + msg);
#end
	}
	
	public static function error(o:Dynamic, msg:Dynamic) {
		trace("Error in " + Type.getClassName(Type.getClass(o)) + ": " + msg);
	}
}