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
			if (Input.isKeyDown(Tobor.KEY_ENTER)) {
				if (menu.currentItem.hasCallback()) {
					menu.currentItem.call();
				} else {
					ok();
				}
				Input.wait(0.25);
			} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
				exit();
				Input.wait(0.25);
			} else if (Input.isKeyDown(Tobor.KEY_UP) || Input.wheelUp()) {
				menu.up();
				Input.wait(0.25);
			} else if (Input.isKeyDown(Tobor.KEY_DOWN) || Input.wheelDown()) {
				menu.down();
				Input.wait(0.25);
			}
			
			if (Input.mouseX >= x + 8 && Input.mouseX < x + w * Tobor.frameSmall.sizeX - 8 && Input.mouseY >= y + 10 && Input.mouseY < y + h * Tobor.frameSmall.sizeY - 10) {
				var mouseSelect:Int = Std.int((Input.mouseY - y) / Tobor.fontSmall.glyphH) - 1;
				menu.select(mouseSelect);
				
				if (Input.mouseBtnLeft) {
					if (menu.currentItem.hasCallback()) {
						menu.currentItem.call();
					} else {
						ok();
					}
					
					// Input.wait(0.25);
					Input.clearKeys();
				}
			} else {
				if (Input.mouseBtnLeft || Input.mouseBtnRight) {
					exit();
					Input.clearKeys();
				}
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