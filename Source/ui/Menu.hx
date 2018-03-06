package ui;

/**
 * ...
 * @author Matthias Faust
 */
class Menu {
	private var items:Array<MenuItem> = new Array<MenuItem>();
	private var selected:Int = 0;
	
	private var inited:Bool = false;
	
	public var w(get, set):Int;
	public var h(get, set):Int;
	
	private var _w:Int = 0;
	private var _h:Int = 0;
	
	public var currentItem(get, null):MenuItem;
	function get_currentItem():MenuItem {
		return items[selected];
	}
	
	public function new() {
		
	}
	
	public inline function set_w(value:Int):Int {
		return _w;
	}
	
	public inline function get_w():Int {
		if (!inited) init();
		
		return _w;
	}
	
	public inline function set_h(value:Int):Int {
		return get_h();
	}
	
	public inline function get_h():Int {
		return items.length;
	}
	
	public function add(name:String, key:String, ?cb:Dynamic) {
		items.push(new MenuItem(name, key, cb));
	}
	
	public function get(index:Int):String {
		return items[index].text;
	}
	
	public function draw(x:Int, y:Int) {
		if (!inited) init();
		
		for (i in 0 ... items.length) {
			if (i == selected) {
				Tobor.fontSmall.drawString(x, y + i * 10, items[i].text, Color.YELLOW, Color.BLACK);
			} else {
				Tobor.fontSmall.drawString(x, y + i * 10, items[i].text, Color.BLACK, Color.WHITE);
			}
		}
	}
	
	private function init() {
		_w = 0;
		
		for (i in 0 ... items.length) {
			if (items[i].text.length > _w) _w = items[i].text.length;
		}
		
		for (i in 0 ... items.length) {
			items[i].resize(_w);
		}
		
		inited = true;
	}
	
	public function down() {
		selected++;
		if (selected >= h) selected = h - 1;
	}
	
	public function up() {
		selected--;
		if (selected < 0) selected = 0;
	}
	
	public function getSelected():Int {
		return selected;
	}
	
	public function select(index:Int) {
		selected = index;
	}
}