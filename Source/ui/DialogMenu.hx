package ui;

/**
 * ...
 * @author Matthias Faust
 */
class DialogMenu extends Dialog {
	var menu:Menu;
	
	public function new(screen:Screen, x:Int, y:Int, list:Array<Array<Dynamic>>) {
		super(screen, x, y);
		
		menu = new Menu();
		
		for (item in list) {
			if (item.length == 2) {
				menu.add(item[0], item[1]);
			} else if (item.length == 3) {
				menu.add(item[0], item[1], item[2]);
			}
		}
		
		h = menu.h + 2;
		w = menu.w + 2;
	}
	
	override public function update(deltaTime:Float) {
		if (child == null) {
			if (Input.isKeyDown([Input.key.RETURN])) {
				if (menu.currentItem.hasCallback()) {
					menu.currentItem.call();
				}
				ok();
				Input.wait(0.25);
			} else if (Input.isKeyDown([Input.key.ESCAPE])) {
				exit();
				Input.wait(0.25);
			} else if (Input.isKeyDown([Input.key.UP])) {
				menu.up();
				Input.wait(0.25);
			} else if (Input.isKeyDown([Input.key.DOWN])) {
				menu.down();
				Input.wait(0.25);
			}
		}
		
		super.update(deltaTime);
	}
	
	override public function render() {
		Tobor.frameSmall.drawBox(x, y, w, h);
				
		menu.draw(x + 8, y + 10);
	}
	
	public function select(index:Int) {
		menu.select(index);
	}
	
	public function getSelected():Int {
		return menu.getSelected();
	}
}