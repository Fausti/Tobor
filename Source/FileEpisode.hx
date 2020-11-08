package;

import haxe.Utf8;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.zip.Tools;
import haxe.zip.Uncompress;
import sys.io.File;
import sys.FileSystem;
import sys.io.FileInput;
import haxe.zip.Reader;

/**
 * ...
 * @author Matthias Faust
 */
class FileEpisode {
	public var name:String = "";
	public var desc:String = "";
	
	var root:String = "";
	
	public var isZIP(default, null):Bool = false;
	public var isEmpty(default, null):Bool = false;
	public var isOK(default, null):Bool = false;
	
	public var isEditor:Bool = false;
	
	public function new(path:Path) {
		if (path == null) {
			isEditor = true;
		}
		
		if (!isEditor) init(path);
	}
	
	public function init(path:Path) {
		this.root = path.toString();
		
		if (FileSystem.isDirectory(path.toString())) {
			isZIP = false;
		} else {
			isZIP = true;
		}
		
		name = path.file;
		
		var content:String = loadFile("info." + Tobor.locale);
		if (content == null) content = loadFile("info." + Tobor.defaultLocale);
		if (content != null) {
			desc = content;
			isOK = true;
		} else {
			isOK = false;
		}
	}
	
	public function create(fileName:String):String {
		var path:Path = null;
		
		if (FileSystem.exists(Files.DIR_EPISODES + '/' + fileName)) {
			isOK = false;
			return Text.get("TXT_DIR_ALREADY_EXISTS");
		} else {
			try 
			{
				FileSystem.createDirectory(Files.DIR_EPISODES + '/' + fileName);	
			}
			catch (err:Dynamic)
			{
				return Text.get("TXT_COULDNT_CREATE_DIR") + ": " + err;
			}
			
			if (FileSystem.exists(Files.DIR_EPISODES + '/' + fileName)) {
				path = new Path(Files.DIR_EPISODES + '/' + fileName);
				isEmpty = true;
			} else {
				return Text.get("TXT_COULDNT_CREATE_DIR");
			}
		}
			
		if (!FileSystem.exists(path.toString() + "/info." + Tobor.defaultLocale)) {
			var fout = File.write(path.toString() + "/info." + Tobor.defaultLocale, false);
			fout.writeString(Text.get("TXT_SET_DESC_IN_INFO_FILE"));
			fout.close();
		}
		
		init(path);
		
		return null;
	}
	
	function checkSavePath() {
		if (!FileSystem.exists(Files.DIR_SAVEGAMES + '/' + name)) {
			try {
				FileSystem.createDirectory(Files.DIR_SAVEGAMES + '/' + name);	
			}
			catch (err:Dynamic)
			{
				trace(err);
			}
		}
	}
	
	public function loadHighscore():String {
		checkSavePath();
		
		return Files.loadFromFile(Files.DIR_SAVEGAMES + '/' + name + '/highscore.dat');
	}
	
	public function saveHighscore(data:String) {
		checkSavePath();
		
		Files.saveToFile(Files.DIR_SAVEGAMES + '/' + name + '/highscore.dat', data);
	}
	
	public function getSavegames():Array<String> {
		var list:Array<String> = [];
		
		for (path in Files.getFiles(Files.DIR_SAVEGAMES + '/' + name, 'sav')) {
			list.push(path.file);
		}
		
		list.sort(function (a:String, b:String) {
			var statA = FileSystem.stat(Files.DIR_SAVEGAMES + '/' + name + '/' + a + ".sav");
			var statB = FileSystem.stat(Files.DIR_SAVEGAMES + '/' + name + '/' + b + ".sav");
			
			if (statA.mtime.getTime() > statB.mtime.getTime()) return -1;
			else if (statA.mtime.getTime() < statB.mtime.getTime()) return 1;
			
			return 0;
		});
		
		return list;
	}
	
	public function loadSavegame(fileName:String):Bytes {
		checkSavePath();
		
		return Files.loadFileAsBytes(Files.DIR_SAVEGAMES + '/' + name + '/' + fileName + '.sav');
	}
	
	public function saveSavegame(fileName:String, data:String) {
		checkSavePath();
		
		Files.saveToFile(Files.DIR_SAVEGAMES + '/' + name + '/' + fileName + '.sav', data);
	}
	
	public function saveSavegame2(fileName:String, data:Bytes) {
		checkSavePath();
		
		Files.saveToFileAsBinary(Files.DIR_SAVEGAMES + '/' + name + '/' + fileName + '.sav', data);
	}
	
	public function hasTexture():Bool {
		if (isZIP) {
			var file:FileInput = File.read(root);
			var unzip:Reader = new Reader(file);
			var files = unzip.read();

			for (e in files) {
				if (e.fileName.endsWithIgnoreCase("tileset.png")) return true;
			}
		} else {
			var fileName = root + "/" + "tileset.png";
			
			if (FileSystem.exists(fileName)) return true;
		}
		
		return false;
	}
	
	public function saveFile(fileName:String, content:String) {
		// können nicht in ZIP Archive speichern
		if (isZIP) return;
		
		fileName = root + "/" + fileName;
		
		try {
			var fout = File.write(fileName, false);
			fout.writeString(content);
			fout.close();
		}
		catch (err:Dynamic)
		{
			trace(err);
		}
	}
	
	public function saveFileAsBytes(fileName:String, content:Bytes) {
		// können nicht in ZIP Archive speichern
		if (isZIP) return;
		
		fileName = root + "/" + fileName;
		
		try {
			var fout = File.write(fileName, true);
			fout.write(content);
			fout.close();
		}
		catch (err:Dynamic)
		{
			trace(err);
		}
	}
	
	public function loadFile(fileName:String):String {
		var content:String = null;
		
		if (isZIP) {
			var file:FileInput = File.read(root);
			// var unzip:Reader = new Reader(file);
			
			var files;
			
			try {
				files = Reader.readZip(file);
				// files = unzip.read();
			} catch (err:Dynamic) {
				trace(err);
				return null;
			}

			var entry = null;
			for (e in files) {
				if (e.fileName.endsWithIgnoreCase(fileName)) entry = e;
			}
			
			if (entry != null) {
				if (entry.compressed) {
					// content = entry.data.toString();
					content = Reader.unzip(entry).toString();
				} else {
					content = entry.data.toString();
				}
			} else {
				trace(fileName + " in " + root + " not found!");
			}
			/*
			var file:FileInput = File.read(root);
			var unzip:Reader = new Reader(file);
			
			var files;
			
			try {
				files = unzip.read();
			} catch (err:Dynamic) {
				trace(err);
				return null;
			}

			var entry = null;
			for (e in files) {
				if (e.fileName.endsWithIgnoreCase(fileName)) entry = e;
			}
			
			if (entry != null) {
				if (entry.compressed) {
					content = Reader.unzip(entry).toString();
				} else {
					content = entry.data.toString();
				}
			} else {
				trace(fileName + " in " + root + " not found!");
			}
			*/
		} else {
			fileName = root + "/" + fileName;
			
			if (FileSystem.exists(fileName)) {
				var fin = File.read(fileName, false);
				content = fin.readAll().toString();
				fin.close();
			} else {
				trace(fileName + " not found!");
			}
		}
		
		return content;
	}
	
	public function loadFileAsBytes(fileName:String):Bytes {
		var content:Bytes = null;
		
		if (isZIP) {
			var file:FileInput = File.read(root);
			var unzip:Reader = new Reader(file);
			var files = unzip.read();

			var entry = null;
			for (e in files) {
				if (e.fileName.endsWithIgnoreCase(fileName)) entry = e;
			}
			
			if (entry != null) {
				if (entry.compressed) {
					content = Reader.unzip(entry);
				} else {
					content = entry.data;
				}
			} else {
				trace(fileName + " in " + root + " not found!");
			}
		} else {
			fileName = root + "/" + fileName;
			
			if (FileSystem.exists(fileName)) {
				var fin = File.read(fileName, true);
				content = fin.readAll();
				fin.close();
			} else {
				trace(fileName + " not found!");
			}
		}
		
		return content;
	}
	
	public function getName(?l:Int = -1):String {
		if (isEditor) return StringTools.rpad(Text.get("TXT_NEW_EPISODE"), ".", l);
		
		if (l == -1) {
			return name;
		} else {
			return name.rpad(".", l);
		}
	}
	
	public function getDesc(l:Int = -1):String {
		if (isEditor) return StringTools.rpad(Text.get("TXT_CREATE_NEW_EPISODE_IN_EDITOR"), ".", l);
		
		if (l == -1) {
			return desc;
		}
		
		return desc.rpad(".", l);
	}
	
	public static function getFiles(path:Path):Array<String> {
		var arr:Array<String> = [];
		
		if (isZipFile(path)) {
			var file:FileInput = File.read(path.toString());
			var unzip:Reader = new Reader(file);
			var files = unzip.read();
			
			for (e in files) {
				arr.push(e.fileName);
			}
		} else if (isDirectory(path)) {
			for (e in FileSystem.readDirectory(path.toString())) {
				arr.push(e);
			}
		}
		
		return arr;
	}
	
	public static function isDirectory(path:Path):Bool {
		if (FileSystem.isDirectory(path.toString())) return true;
		return false;
	}
	public static function isZipFile(path:Path):Bool {
		if (path.ext.toLowerCase() == "zip") return true;
		return false;
	}
	
	public static function isEpisodeFile(fileName:String):Bool {
		var path:Path = new Path(fileName);
		
		if (isZipFile(path)) {
			var hasRooms:Bool = false;
			var content:Array<String> = getFiles(path);

			for (file in content) {
				if (file.endsWithIgnoreCase("rooms.json")) {
					hasRooms = true;
				}
			}
			
			return (hasRooms);
		}
		
		return false;
	}
	
	public static function install(fileName:String) {
		var path:Path = new Path(fileName);
		
		try {
			File.copy(fileName, Files.DIR_EPISODES + '/' + path.file + '.' + path.ext);
		} catch (err:Dynamic) {
			trace(err);
		}
	}
}