package ui;

import gfx.Batch;
/**
 * ...
 * @author Matthias Faust
 */
class Screen {
	public var game:Tobor;
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
	
	public function showDialog(d:Dialog) {
		Input.clearKeys();
		
		if (this.dialog != null) {
			if (this.dialog != d) {
				this.dialog.hide();
			}
		}
		
		this.dialog = d;
		if (d != null) d.show();
	}
	
	public function hideDialog() {
		Input.clearKeys();
		
		if (this.dialog != null) {
			this.dialog.hide();
			this.dialog = null;
		}
	}
	
	public function onTextInput(text:String) {
		if (this.dialog != null) {
			this.dialog.onTextInput(text);
		}
	}
}