package;

import haxe.zip.Reader;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
import sys.io.FileInput;

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
			
			if (ext != "*") {
				if (path.ext == ext && !FileSystem.isDirectory(path.toString())) {
					list.push(path);
				}
			} else {
				if (!FileSystem.isDirectory(path.toString())) {
					list.push(path);
				}
			}
		}
		
		return list;
	}
	
	public static function getDirsAndFiles(dirName:String, ?list:Array<Path> = null):Array<Path> {
		if (list == null) list = [];
		
		for (fileName in FileSystem.readDirectory(dirName)) {
			var path = new Path(dirName + "/" + fileName);
			
			if (path.ext == "zip") {
				list.push(path);
			} else if (FileSystem.isDirectory(path.toString())) {
				list.push(path);
			}
		}
		
		return list;
	}
	
	public static function getContent(path:Path):Array<Path> {
		var list:Array<Path> = [];
		
		if (FileSystem.isDirectory(path.toString())) {
			getFiles(path.toString(), "*", list);
		} else {
			var file:FileInput = File.read(path.toString());
			var unzip:Reader = new Reader(file);
			
			for (e in unzip.read()) {
				list.push(new Path(e.fileName));
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
		var fin:FileInput;
		
		try 
		{
			fin = File.read(fileName, false);
		}
		catch (err:Dynamic)
		{
			return null;
		}
		
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
		try {
			var fout = File.write(fileName, false);
			fout.writeString(data);
			fout.close();
		}
		catch (err:Dynamic)
		{
			trace(err);
		}
	}
}