package screens;

import ui.Screen;
import ui.DialogMenu;

/**
 * ...
 * @author Matthias Faust
 */
class GameScreen extends Screen {

	public function new(game:Tobor) {
		super(game);
	}
	
		function showSpeedMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_MENU_SPEED_SLOWEST"), "", function () {
				Config.setSpeed(0);
				hideDialog();
			}],
			[Text.get("TXT_MENU_SPEED_SLOW"), "", function () {
				Config.setSpeed(1);
				hideDialog();
			}],
			[Text.get("TXT_MENU_SPEED_NORMAL"), "", function () {
				Config.setSpeed(2);
				hideDialog();
			}],
			[Text.get("TXT_MENU_SPEED_FAST"), "", function () {
				Config.setSpeed(3);
				hideDialog();
			}],
			[Text.get("TXT_MENU_SPEED_FASTEST"), "", function () {
				Config.setSpeed(4);
				hideDialog();
			}],
		]);
		
		menu.select(Config.speed);
		
		menu.onCancel = function () {
			showOptionMenu(atX, atY);
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showRobotBehaviorMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_MENU_ROBOT_BEHAVIOR_NEW"), "", function () {
				Config.setRobotBehavior(0);
				hideDialog();
			}],
			[Text.get("TXT_MENU_ROBOT_BEHAVIOR_OLD"), "", function () {
				Config.setRobotBehavior(1);
				hideDialog();
			}],
		]);
		
		menu.select(Config.robotBehavior);
		
		menu.onCancel = function () {
			showOptionMenu(atX, atY);
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showRobotStressMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_OFF"), "", function () {
				Config.setRobotStress(false);
				hideDialog();
			}],
			[Text.get("TXT_ON"), "", function () {
				Config.setRobotStress(true);
				hideDialog();
			}],
		]);
		
		menu.select(Config.robotStress?1:0);
		
		menu.onCancel = function (atX, atY) {
			showOptionMenu();
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showKeysMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_OFF"), "", function () {
				Config.setColoredKeys(false);
				if (Std.is(game.getScreen(), PlayScreen)) game.world.inventory.refresh(game.world.factory);
				hideDialog();
			}],
			[Text.get("TXT_ON"), "", function () {
				Config.setColoredKeys(true);
				if (Std.is(game.getScreen(), PlayScreen)) game.world.inventory.refresh(game.world.factory);
				hideDialog();
			}],
		]);
		
		menu.select(Config.colorKeys?1:0);
		
		menu.onCancel = function (atX, atY) {
			showOptionMenu();
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showLightMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("Dithering"), "", function () {
				Config.light = 0;
				hideDialog();
			}],
			[Text.get("Smooth"), "", function () {
				Config.light = 1;
				hideDialog();
			}],
			[Text.get("Both"), "", function () {
				Config.light = 2;
				hideDialog();
			}],
		]);
		
		menu.select(Config.light);
		
		menu.onCancel = function () {
			showOptionMenu(atX, atY);
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showShaderMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("Normal"), "", function () {
				Config.setShader(-1);
				hideDialog();
			}],
			[Text.get("HQ2X"), "", function () {
				Config.setShader(0);
				hideDialog();
			}],
			[Text.get("HQ4X"), "", function () {
				Config.setShader(1);
				hideDialog();
			}],
		]);
		
		menu.select(Config.shader + 1);
		
		menu.onCancel = function () {
			showOptionMenu(atX, atY);
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showOptionMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[game.isFullscreen()?Text.get("TXT_WINDOW"):Text.get("TXT_FULLSCREEN"), "", function () {
				game.toggleFullscreen();
				hideDialog();
			}],
			["", "", function () {
				
			}],
			[Text.get("TXT_MENU_SPEED"), ">>", function () {
				showSpeedMenu(atX, atY);
			}],
			[Text.get("TXT_MENU_SHADER"), ">>", function () {
				showShaderMenu(atX, atY);
			}],
			[Text.get("TXT_MENU_LIGHT"), ">>", function () {
				showLightMenu(atX, atY);
			}],
			[Text.get("TXT_MENU_KEYS"), ">>", function () {
				showKeysMenu(atX, atY);
			}],
			["- Debug -", "", function () {
				
			}],
			[Text.get("TXT_MENU_ROBOT_STRESS"), ">>", function () {
				showRobotStressMenu(atX, atY);
			}],
			[Text.get("TXT_MENU_ROBOT_BEHAVIOR"), ">>", function () {
				showRobotBehaviorMenu(atX, atY);
			}],
		]);
		
		menu.select(0);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
}