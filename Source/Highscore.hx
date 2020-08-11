package;
import tjson.TJSON;

/**
 * ...
 * @author Matthias Faust
 */
class Highscore {
	var SPR_NONE:Sprite;
	var scores:Array<HighscoreEntry>;
	
	public function new() {
		SPR_NONE = Gfx.getSprite(0, 0);
		scores = [];
	}
	
	public function draw(x:Int, y:Int) {
		var index:Int = 0;
		var scoreString:String;
		
		Gfx.drawTexture(x, y, 512, 100, SPR_NONE.uv, Color.WHITE);
		
		for (s in scores) {
			scoreString = Std.string(index + 1).lpad(" ", 2);
			scoreString += " " + s.name.left(15).lpad(" ", 15); 
			scoreString += ": " + StringTools.lpad(Std.string(s.points), " ", 7); 
			scoreString += " (" + StringTools.lpad(Std.string(s.rooms), " ", 2) + ")";

			Tobor.fontBig.drawString(x, y + index * 10, scoreString, Color.BLACK, Color.WHITE);
			index++;
		}
	}
	
	public function sort() {
		scores.sort(function(a:HighscoreEntry, b:HighscoreEntry) {
			if (a.points == b.points) {
				if (a.rooms < b.rooms) {
					return 1;
				} else if (a.rooms > b.rooms) {
					return -1;
				} else {
					return 0;
				}
			} else if (a.points < b.points) {
				return 1;
			} else if (a.points > b.points) {
				return -1;
			} else {
				return 0;
			}
		});
		
		while (scores.length > 10) {
			scores.pop();
		}
	}
	
	public function add(name:String, points:Int, rooms:Int) {
		if (points <= 0) return;
		
		scores.push(new HighscoreEntry(name, points, rooms));
		
		sort();
	}
	
	public function save():String {
		var data:Array<Dynamic> = [];
		
		for (s in scores) {
			data.push(s.save());
		}
		
		return TJSON.encode(data, 'fancy');
	}
	
	public function load(fileData:String) {
		scores = [];
		
		if (fileData == "" || fileData == null) {
			init();
			return;
		}
		
		var data:Array<Dynamic> = TJSON.parse(fileData);
		
		for (entry in data) {
			var _name:String = Reflect.field(entry, "name");
			var _points:Int = Reflect.field(entry, "points");
			var _rooms:Int = Reflect.field(entry, "rooms");
			
			add(_name, _points, _rooms);
		}
		
		sort();
	}
	
	public function init() {
		add("Unglaublicher", 400000, 30);
		add("Supermeister", 250000, 18);
		add("Der Meister", 100000, 11);
		add("Der Aufsteiger", 25000, 8);
		add("Der Anfänger", 10000, 4);
	}
}

class HighscoreEntry {
	public var name:String = "";
	public var points:Int = 0;
	public var rooms:Int = 0;
	
	public function new(name:String, points:Int, rooms:Int) {
		set(name, points, rooms);
	}
	
	public function set(name:String, points:Int, rooms:Int) {
		this.name = name;
		this.points = points;
		this.rooms = rooms;
	}
	
	public function save():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		data.set("name", name);
		data.set("points", points);
		data.set("rooms", rooms);
		
		return data;
	}
}