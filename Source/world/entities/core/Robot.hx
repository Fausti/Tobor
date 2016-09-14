package world.entities.core;

import gfx.Animation;
import gfx.Color;
import world.entities.ObjectAI;

/**
 * ...
 * @author Matthias Faust
 */
class Robot extends ObjectAI {
	var anim:Array<Animation> = [];
	var col:Array<Color> = [];
	
	public function new(?type:Int = 0) {
		type = Std.random(6);
		super(type);
		
		speed = 1 / 4;
		
		var p0:Animation = null;
		var p1:Animation = null;
		var p2:Animation = null;
		
		switch(type) {
			case 0:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_0_PART_2_1"));
				
				p2.setSpeed(speed);
			case 1:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_1_PART_2_1"));
				
				p2.setSpeed(speed);
			case 2:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_2_PART_2_1"));
				
				p2.setSpeed(speed);
			case 3:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_3_PART_2_1"));
				
				p2.setSpeed(speed);
			case 4:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_4_PART_2_1"));
				
				p2.setSpeed(speed);
			case 5:
				p0 = new Animation();
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_0_0"));
				p0.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_0_1"));
				
				p0.setSpeed(speed);
				
				p1 = new Animation();
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_1_0"));
				p1.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_1_1"));
				
				p1.setSpeed(speed);
				
				p2 = new Animation();
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_2_0"));
				p2.addFrame(Tobor.Tileset.find("SPR_ROBOT_5_PART_2_1"));
				
				p2.setSpeed(speed);
			default:
		}
		
		anim.push(p0);
		anim.push(p1);
		anim.push(p2);
		
		col.push(Color.palette[Std.random(Color.palette.length - 1)]);
		col.push(Color.palette[Std.random(Color.palette.length - 1)]);
		col.push(Color.palette[Std.random(Color.palette.length - 1)]);
		
		p0.start();
		p1.start();
		p2.start();
	}
	
	override
	public function draw() {
		var cIndex:Int = 0;
		
		for (a in anim) {
			Gfx.drawTexture(x, y, 16, 12, a.getUV(), col[cIndex]);
			cIndex++;
		}
	}
	
	override public function saveData():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var id:Int = EntityFactory.findID("OBJ_ROBOT", 0);
		var def:EntityTemplate = EntityFactory.table[id];
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("x", gridX);
			data.set("y", gridY);
		}
		
		return data;
	}
}