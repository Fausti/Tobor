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
	
	public function new(path:Path) {
		if (path == null) {
			if (FileSystem.exists(Files.DIR_EPISODES + '/__NEU__')) {
				isOK = false;
				return;
			} else {
				FileSystem.createDirectory(Files.DIR_EPISODES + '/__NEU__');
				path = new Path(Files.DIR_EPISODES + '/__NEU__');
				isEmpty = true;
			}
			
			if (!FileSystem.exists(path.toString() + '/info.txt')) {
				var fout = File.write(path.toString() + '/info.txt', false);
				fout.writeString("Eine neue Episode im Editor erstellen");
				fout.close();
			}
		}
		
		this.root = path.toString();
		
		if (FileSystem.isDirectory(path.toString())) {
			isZIP = false;
		} else {
			isZIP = true;
		}
		
		name = path.file;
		
		var content:String = loadFile("info.txt");
		if (content != null) {
			desc = content;
			isOK = true;
		} else {
			isOK = false;
		}
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
	
	public function getName(l:Int):String {
		return name.rpad(l, ".", false);
	}
	
	public function getDesc(l:Int):String {
		return desc.rpad(l, ".", false);
	}
}