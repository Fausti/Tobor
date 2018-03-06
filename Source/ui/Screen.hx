package ui;

import gfx.Batch;
/**
 * ...
 * @author Matthias Faust
 */
class Screen {
	var game:Tobor;
	var batch:Batch;
	var dialog:Dialog;
	
	public function new(game:Tobor) {
		this.game = game;
		this.batch = game.batch;
	}
	
	public function show() {
		
	}
	
	public function hide() {
		
	}
	
	public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		}
	}
	
	public function render() {
		
	}
	
	public function renderUI() {
		if (dialog != null) dialog.render();
	}
	
	public function showDialog(dialog:Dialog) {
		Input.clearKeys();
		
		if (this.dialog != null) {
			if (this.dialog != dialog) {
				if (dialog != null) dialog.hide();
			}
		}
		
		this.dialog = dialog;
		if (dialog != null) dialog.show();
	}
	
	public function hideDialog() {
		Input.clearKeys();
		
		if (dialog != null) {
			dialog.hide();
			dialog = null;
		}
	}
}