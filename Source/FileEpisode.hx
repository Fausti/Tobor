package;

import haxe.Utf8;
import haxe.io.Path;
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
	
	public function saveFile(fileName:String, content:String) {
		fileName = root + "/" + fileName;
		
		var fout = File.write(fileName, false);
		fout.writeString(content);
		fout.close();
	}
	
	public function loadFile(fileName:String):String {
		var content:String = null;
		
		if (isZIP) {
			var file:FileInput = File.read(root);
			var unzip:Reader = new Reader(file);
			var files = unzip.read();
			
			var entry = null;
			for (e in files) {
				if (e.fileName == fileName) entry = e;
			}
			
			if (entry != null) {
				content = Utf8.encode(entry.data.toString());
			} else {
				trace(fileName + " in " + root + " not found!");
			}
		} else {
			fileName = root + "/" + fileName;
			
			if (FileSystem.exists(fileName)) {
				var fin = File.read(fileName, false);
				content = Utf8.encode(fin.readAll().toString());
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
			return name.rpad(l, ".", false);
		}
	}
	
	public function getDesc(l:Int):String {
		if (isEditor) return StringTools.rpad(Text.get("TXT_CREATE_NEW_EPISODE_IN_EDITOR"), ".", l);
		return desc.rpad(l, ".", false);
	}
}