package world;

import Reflect;
/**
 * ...
 * @author Matthias Faust
 */
class EntityTemplate {
	public var name:String;
	public var subType:Int;
	public var classPath:String;
	public var editorSprite:String;
	
	public var error:String = null;
	
	public function new(entry:Dynamic) {
		name =			Reflect.getProperty(entry, "name");
		classPath = 	Reflect.getProperty(entry, "classPath");
		editorSprite = 	Reflect.getProperty(entry, "editorSprite");
			
		subType = 0;
		if (Reflect.hasField(entry, "subType")) subType = Reflect.getProperty(entry, "subType");
		
		if (Type.resolveClass(classPath) == null) {
			error = "PARSE ERROR: Klasse '" + classPath + "' existiert nicht!";
		}
	}
}