package screens;

import world.Room;
import world.entities.core.Charlie;
import world.entities.Object;
import world.entities.ObjectPushable;
import world.entities.core.Wall;
import lime.Assets;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector4;
import lime.utils.Float32Array;
import gfx.Batch;
import gfx.Color;
import gfx.Gfx;
import dialog.Dialog;

import gfx.Gfx.gl;

/**
 * ...
 * @author Matthias Faust
 */
class Screen {
	var game:Tobor;
	
	public var batchStatic:Batch;
	public var batchSprites:Batch;
	
	var backgroundColor = Color.WHITE;
	var color:Color = Color.WHITE;
	
	var dialog:Dialog;
	
	public function new(game:Tobor) {
		this.game = game;
		game.world.room.redraw = true;
		
		batchStatic = new Batch(true);
		batchSprites = new Batch(true);
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
	
	public function onMouseMove(x:Float, y:Float) {
		
	}
	
	public function showDialog(dialog:Dialog) {
		if (this.dialog != null) {
			if (this.dialog != dialog) {
				if (dialog != null) dialog.hide();
			}
		}
		
		this.dialog = dialog;
		if (dialog != null) dialog.show();
	}
	
	public function hideDialog() {
		if (dialog != null) {
			dialog.hide();
			dialog = null;
		}
	}
}