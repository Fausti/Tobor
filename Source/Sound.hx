package;

import lime.utils.Assets;
import lime.media.AudioBuffer;
import lime.media.AudioSource;

/**
 * ...
 * @author Matthias Faust
 */
class Sound {
	static var LIMIT_PER_SOUND:Int = 3;
	static var _playing:Array<AudioSource> = [];
	
	public static var MUS_CHOOSER:AudioBuffer;
	public static var MUS_INTRO_DOS:AudioBuffer;
	
	public static var MUS_NATURE:AudioBuffer;
	
	public static var SND_CHARLIE_STEP:AudioBuffer;
	public static var SND_TUNNEL_STEP:AudioBuffer;
	public static var SND_ROBOT_STEP:AudioBuffer;
	
	public static var SND_DISSOLVE_WALL:AudioBuffer;
	
	public static var SND_PICKUP_MISC:AudioBuffer;
	public static var SND_PICKUP_KEY:AudioBuffer;
	public static var SND_PICKUP_GOLD:AudioBuffer;
	
	public static var SND_ROTATE_ARROW:AudioBuffer;
	
	public static var SND_OPEN_DOOR:AudioBuffer;
	
	public static var SND_EXPLOSION_CHARLIE:AudioBuffer;
	public static var SND_EXPLOSION_ROBOT:AudioBuffer;
	
	public static var SND_SHOOT_BULLET:AudioBuffer;
	
	public static var SND_JINGLE_0:AudioBuffer;
	public static var SND_JINGLE_1:AudioBuffer;
	
	public static var SND_USE_GARLIC:AudioBuffer;
	
	public static var listMusic:Map<String, AudioBuffer>;
	
	public static function init() {
		listMusic = new Map<String, AudioBuffer>();
		
		MUS_CHOOSER = Assets.getAudioBuffer("assets/mus/chooser.ogg");
		MUS_INTRO_DOS = Assets.getAudioBuffer("assets/mus/intro-dos.ogg");
		
		MUS_NATURE = Assets.getAudioBuffer("assets/mus/nature.ogg");
		listMusic.set("MUS_NATURE", MUS_NATURE);
		
		SND_CHARLIE_STEP = Assets.getAudioBuffer("assets/sfx/step-charlie.ogg");
		SND_TUNNEL_STEP = Assets.getAudioBuffer("assets/sfx/step-tunnel.ogg");
		SND_ROBOT_STEP = Assets.getAudioBuffer("assets/sfx/step-robot.ogg");
		
		SND_DISSOLVE_WALL = Assets.getAudioBuffer("assets/sfx/dissolve-wall.ogg");
		
		SND_PICKUP_MISC = Assets.getAudioBuffer("assets/sfx/pickup-misc.ogg");
		SND_PICKUP_KEY = Assets.getAudioBuffer("assets/sfx/pickup-key.ogg");
		SND_PICKUP_GOLD = Assets.getAudioBuffer("assets/sfx/pickup-gold.ogg");
		
		SND_USE_GARLIC = Assets.getAudioBuffer("assets/sfx/use-garlic.ogg");
		
		SND_ROTATE_ARROW = Assets.getAudioBuffer("assets/sfx/drop-magnet.ogg");
		
		SND_OPEN_DOOR = Assets.getAudioBuffer("assets/sfx/open-door.ogg");
		
		SND_JINGLE_0 = Assets.getAudioBuffer("assets/sfx/jingle-0.ogg");
		SND_JINGLE_1 = Assets.getAudioBuffer("assets/sfx/jingle-1.ogg");
		
		SND_EXPLOSION_CHARLIE = Assets.getAudioBuffer("assets/sfx/explosion.ogg");
		SND_EXPLOSION_ROBOT = Assets.getAudioBuffer("assets/sfx/explosion-short.ogg");
		
		SND_SHOOT_BULLET = Assets.getAudioBuffer("assets/sfx/shoot-bullet.ogg");
	}
	
	public static function stopMusicAll() {
		for (key in listMusic.keys()) {
			stopMusic(key);
		}
	}
	
	public static function stopMusic(key:String) {
		if (key == null || key == "") return;
		
		var m = listMusic.get(key);
		
		if (m != null) stop(m);
	}
	
	public static function playMusic(key:String) {
		if (key == null || key == "") return;
		
		var m = listMusic.get(key);
		
		if (m != null) play(m, true);
	}
	
	private static function findPlaying(sound:AudioBuffer):Array <AudioSource> {
		return _playing.filter(function(f:AudioSource) {
			return f.buffer == sound;
		});
	}
	public static function stop(sound:AudioBuffer) {
		var list = findPlaying(sound);
		
		if (list.length > 0) {
			for (s in list) {
				s.stop();
				s.dispose();
				_playing.remove(s);
			}
		}
	}
	
	public static function play(sound:AudioBuffer, ?repeat:Bool = false) {
		var list = findPlaying(sound);
		if (list.length >= LIMIT_PER_SOUND) return;
		
		var snd:AudioSource = new AudioSource(sound);
		_playing.push(snd);
		
		if (repeat) {
			snd.onComplete.add(function() {_playing.remove(snd); play(sound, true); });
		} else {
			snd.onComplete.add(function() {_playing.remove(snd); });
		}
		
		snd.play();
	}
	
}