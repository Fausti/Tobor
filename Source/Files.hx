package;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;

/**
 * ...
 * @author Matthias Faust
 */
class Files {
	public static inline var DIR_SAVEGAMES:String = "saves";
	public static inline var DIR_EPISODES:String = "games";
	
	public static function init() {
		initDirectories();
	}

	static function initDirectories() {
		initDirectory(DIR_SAVEGAMES);
		initDirectory(DIR_EPISODES);
	}
	
	static function initDirectory(dirName:String) {
		if (!FileSystem.isDirectory(dirName)) {
			FileSystem.createDirectory(dirName);
		}
	}
	
	public static function getFiles(dirName:String, ext:String, ?list:Array<Path> = null):Array<Path> {
		if (list == null) list = [];
		
		for (fileName in FileSystem.readDirectory(dirName)) {
			var path = new Path(dirName + "/" + fileName);
			
			if (path.ext == ext) {
				list.push(path);
			}
		}
		
		return list;
	}
	
	public static function loadHeader(fileName:String):String {
		var fin = File.read(fileName, false);
		
		// erste Zeile lesen, falls Kommentar vorhanden
		var header = fin.readLine();
		if (header.indexOf("//") == 0) {
			header = header.substr(2);
		} else {
			header = "";
		}
		
		fin.close();
		
		return header;
	}
	
	public static function loadFromFile(fileName:String):String {
		var fin = File.read(fileName, false);
		
		// erste Zeile lesen, falls Kommentar vorhanden
		var header = fin.readLine();
		if (header.indexOf("//") == 0) {
			header = header.substr(2);
			
			header = "";
		}
		
		// Rest der Datei lesen
		var fileData = header + fin.readAll().toString();
		fin.close();
		
		return fileData;
	}
	
	public static function saveToFile(fileName:String, data:String) {
		var fout = File.write(fileName, false);
		fout.writeString(data);
		fout.close();
	}
}