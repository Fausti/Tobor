package dialog;
import screens.Screen;

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
			if (Input.keyDown(Input.ENTER)) {
				if (menu.currentItem.hasCallBack()) {
					menu.currentItem.call();
				}
				ok();
				Input.wait(0.25);
			} else if (Input.keyDown(Input.ESC)) {
				exit();
				Input.wait(0.25);
			} else if (Input.keyDown(Input.UP)) {
				menu.up();
				Input.wait(0.25);
			} else if (Input.keyDown(Input.DOWN)) {
				menu.down();
				Input.wait(0.25);
			}
		}
		
		super.update(deltaTime);
	}
	
	override public function render() {
		Tobor.Frame8.drawBox(x, y, w, h);
				
		menu.draw(x + 8, y + 10);
	}
	
	public function select(index:Int) {
		menu.select(index);
	}
	
	public function getSelected():Int {
		return menu.getSelected();
	}
}