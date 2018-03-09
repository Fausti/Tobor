package;

/**
 * ...
 * @author Matthias Faust
 */
class Highscore {
	var scores:Array<HighscoreEntry>;
	
	public function new() {
		scores = [];
	}
	
	public function draw(x:Int, y:Int) {
		var index:Int = 0;
		var scoreString:String;
		
		for (s in scores) {
			scoreString = Std.string(index + 1).lpad(2, " ");
			scoreString += " " + s.name.left(15).lpad(15, " "); 
			scoreString += ": " + StringTools.lpad(Std.string(s.points), " ", 7); 
			scoreString += " (" + StringTools.lpad(Std.string(s.rooms), " ", 2) + ")";

			Tobor.fontBig.drawString(x, y + index * 10, scoreString, Color.BLACK, Color.WHITE);
			index++;
		}
	}
	
	public function add(name:String, points:Int, rooms:Int) {
		scores.push(new HighscoreEntry(name, points, rooms));
		
		scores.sort(function(a:HighscoreEntry, b:HighscoreEntry) {
			if (a.points == b.points) {
				if (a.rooms < b.rooms) {
					return -1;
				} else if (a.rooms > b.rooms) {
					return 1;
				} else {
					return 0;
				}
			} else if (a.points < b.points) {
				return -1;
			} else if (a.points > b.points) {
				return 1;
			} else {
				return 0;
			}
		});
		
		while (scores.length > 10) {
			scores.pop();
		}
	}
	
	public function load() {
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
}